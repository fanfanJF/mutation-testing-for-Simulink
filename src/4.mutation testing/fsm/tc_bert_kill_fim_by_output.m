clc;

mutant_dir = "FIM_muts";
mutants_list_ = dir(mutant_dir);
cd FIM_muts;

%extracting mutants names
mutants_list = [];
for i = 1:length(mutants_list_)
    if contains(mutants_list_(i).name, ".slx") && ~contains(mutants_list_(i).name, ".autosave")
        mutants_list = [mutants_list, string(mutants_list_(i).name)];
    end
end
mutants_list = erase(mutants_list, ".slx");
original_model = mutants_list(1);
mutants_list = mutants_list(2:end);
number_of_mutants = length(mutants_list);

cd ../..
open_system("fimtool-main/FaultInjector_Master/FInjLib");%local
set_param(gcs, 'Lock', 'off');
save_system(gcs);
cd fsm/FIM_muts;

mutants_index = [1:number_of_mutants];
cd ..;
testSuit = readmatrix("fsm_input.csv");
file = fopen('tcbert_kill_fim_output.json', 'w');
TSbert={1,2,3,4,5,6,9,11,15,16};
dictionaryCellArray = cell(length(TSbert), 1);

for i=1:length(TSbert)
    input_1 = testSuit(TSbert{i}, :);
    killed_muts={};
    %run tests on the original model
    [output_org, fitness_org] = compute_fsm(convertStringsToChars(original_model), input_1);
    for m=1:number_of_mutants
        mutant=mutants_list(m);
        try
            [output, fitness] = compute_fsm(convertStringsToChars(mutant), input_1);
        catch error
            output=output_org;
            fitness=fitness_org;
        end

        for i = 1:length(output)
            if ~isequal(cell2mat(output_org(i)), cell2mat(output(i)))
                killed_muts=[killed_muts,num2str(m)];
                break;
            end
        end

        close_system(mutant, 0);
    end
    dictionaryCellArray{i}=killed_muts;
    
end
cd ..;
fprintf(file, jsonencode(dictionaryCellArray)); 
fclose(file);

cd fsm;




