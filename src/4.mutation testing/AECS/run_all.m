

run('tc_test_bert_fitness.m')
run('tc_test_FIM_fitness.m')
run('tc_test_bert_output.m')
run('tc_test_FIM_output.m')
run('tc_test_bert_req.m')
run('tc_test_FIM_req.m')


run("tc_bert_kill_fim_by_fitness.m")
run("tc_bert_kill_fim_by_output.m")
run("tc_bert_kill_fim_by_req.m")
run('tc_FIM_kill_bert_by_fitness.m')
run('tc_FIM_kill_bert_by_output.m')
run('tc_FIM_kill_bert_by_req.m')

run("TSbert_violate_req.m")
run("TSFIM_violate_req.m")