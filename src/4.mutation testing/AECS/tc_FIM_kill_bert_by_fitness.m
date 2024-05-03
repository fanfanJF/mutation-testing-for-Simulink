clc;

mutant_dir = "bert_muts";
mutants_list_ = dir(mutant_dir);
cd bert_muts;

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


mutants_index = [1:number_of_mutants];
cd ..;
testSuit = readmatrix("AECS_input.csv");
file = fopen('tcfim_kill_bert_fitness.json', 'w');
TSFIM={1,2,6};
dict = containers.Map;

for i=1:length(TSFIM)
    input_1 = testSuit(TSFIM{i});
    killed_muts={};
    %run tests on the original model
    [output_org, fitness_org] = compute_AECS(convertStringsToChars(original_model), input_1);
    for m=1:number_of_mutants
        mutant=mutants_list(m);
        try
            [output, fitness] = compute_AECS(convertStringsToChars(mutant), input_1);
        catch error
            output=output_org;
            fitness=fitness_org;
        end

        found = false;
        for i = 1:length(fitness)
            if ~isequal(cell2mat(fitness_org), cell2mat(fitness))
                found = true;
                killed_muts=[killed_muts,num2str(m)];
                break;
            end
        end

        close_system(mutant, 0);
    end
    dict(num2str(i))=killed_muts;
    
end

fprintf(file, jsonencode(dict)); 
fclose(file);




