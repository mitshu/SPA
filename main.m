function main
clc
clear vars
clear all
close all
%
for n = 150%:50:1000 %size of residents
k = 1;  %the number of instances has the same (n,m,p1,p2)
    for alg = 1:2
        m = n/10;
        q = n/5;
        p = 0.5; 
            f_results= [];
            i = 1;
            while (i <= k)
                %load the preference matrices and the matching from file
                filename = ['Error\I(',num2str(n),',',num2str(m),',',num2str(q),',',num2str(p,'%.1f'),',',')-',num2str(i),'.mat'];
                load(filename,'lect_rank_list','lect_caps_list','proj_caps_list','stud_rank_list');
                %run algorithms
                if (alg == 1)                    
                    [f_time,f_cost,M] = SPA_P_approx(stud_rank_list, lect_rank_list, lect_caps_list, proj_caps_list);
                    f_results = [f_results; f_time,f_cost];
                %
                    fprintf('\nI(%d,%d,%d): time = %3.3f, fcost = %d',n,m,q,f_time,f_cost);
                %
                    %filename2 = ['outputs\SPA_P_approx(',num2str(n),',',num2str(m),',',num2str(q,'%.1f'),',',num2str(p,'%.1f'),')-',num2str(i),').mat'];
                    %save(filename2,'f_results');
                end
                if (alg == 2)
                    [f_time,f_cost,M]= SPA_P_approx_promotion(stud_rank_list, lect_rank_list, lect_caps_list, proj_caps_list);
                    f_results = [f_results; f_time,f_cost];
                %
                    fprintf('\nI(%d,%d,%d): time = %3.3f, fcost = %d',n,m,q,f_time,f_cost);
                %
                    %filename2 = ['outputs\promotion(',num2str(n),',',num2str(m),',',num2str(q,'%.1f'),',',num2str(p,'%.1f'),')-',num2str(i),').mat'];
                    %save(filename2,'f_results');
                end
                %
                i = i + 1;
            end
            %
            %save to file for averaging results
            %if (alg == 1)
            %    filename2 = ['outputs\MCA(',num2str(n),',',num2str(m),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),').mat'];
            %    save(filename2,'f_results');
            %end
%             if (alg == 2)
%                 filename2 = ['outputs\LTIU(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
%                 save(filename2,'f_results');
%             end
        end
    end
end
%==========================================================================