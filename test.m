clc;
clear all;
close all;

stu_rank_list = [1 0 3 2 0
2 0 0 0 1
0 1 0 0 2
0 2 0 1 0
0 2 0 0 1];

lec_rank_list = [1 2 3 0 0
    0 0 0 1 2];
lec_caps_list = [3 2];
proj_caps_list = [1 2 1 1 2];
M = [3 0 5 2 5
     1 0 2 1 2];
f = matching_cost(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list,M)
% M = SPA_P_approx(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list)
% M = SPA_P_approx_promotion(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list)


% 
% stu_rank_list = [1 2 0 0 0 3
% 1 0 0 2 0 0
% 1 2 0 0 3 0
% 0 0 1 0 0 0
% 0 0 1 0 2 0
% 0 0 2 0 1 3];
% 
% lec_rank_list = [2 3 1 4 0 0
%     0 0 0 0 1 2];
% lec_caps_list = [3 3];
% proj_caps_list = [2 2 1 1 1 2];
% M = SPA_P_approx_promotion(stu_rank_list, lec_rank_list, lec_caps_list, proj_ca
%==========================
% stu_rank_list = [0 1 0 0 
% 2 0 1 0 
% 0 0 1 2];
% lec_rank_list = [1 2 0 0
% 0 0 1 0
% 0 0 0 1];
% lec_caps_list = [1 1 1];
% proj_caps_list = [1 1 1 1];
%[f_time,f_cost,M] = SPA_P_approx_promotion(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list)
%M = SPA_P_approx(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list)


% stud_rank_list = [1 2 0 0 0 3
% 1 0 0 2 0 0
% 1 2 0 0 3 0
% 0 0 1 0 0 0
% 0 0 1 0 2 0
% 0 0 2 0 1 3];
% 
% lect_rank_list = [2 3 1 4 0 0
%     0 0 0 0 1 2];
% lect_caps_list = [3 3];
% proj_caps_list = [1 1 1 1 1 1];
%filename = ['tests\I(',num2str(100),',',num2str(10),',',num2str(20),',',num2str(0.5,'%.1f'),',',')-',num2str(1),'.mat'];
%load(filename,'lect_rank_list','lect_caps_list','proj_caps_list','stud_rank_list');
%SPA_P_approx(stud_rank_list, lect_rank_list, lect_caps_list, proj_caps_list)
%SPA_P_approx_promotion(stud_rank_list, lect_rank_list, lect_caps_list, proj_caps_list)

