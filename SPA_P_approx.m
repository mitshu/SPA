function [f_time,f_cost,M] = SPA_P_approx(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list)
n = size(stu_rank_list,1);
m = size(lec_rank_list,1);
c = size(proj_caps_list,2);
M = zeros(2,n);
stu_pref_list = zeros(n,c);
lec_pref_list = zeros(m,c);
% valid student
valid_stu = ones(1,n);
tic;
%change to stu_pref_list from stu_rank_list
for i = 1:n
    for j = 1:length(find(stu_rank_list(i,:)~=0))
        stu_pref_list(i,j) = find(stu_rank_list(i,:)==j);
    end
end
%change to lec_pref_list from lec_rank_list
for i = 1:m
    for j = 1:length(find(lec_rank_list(i,:)~=0))
        lec_pref_list(i,j) = find(lec_rank_list(i,:)==j);
    end
end
%algorithm
while(sum(valid_stu==0) < n)
        si = find(valid_stu==1,1,'first');
        %check valid student condition
        if (valid_stu(si) == 0)
            continue;
        end
        if (M(1,si)==0 && sum(stu_pref_list(si,:)==0)==c) || (M(1,si)~=0)  
            valid_stu(si) = 0;
            continue;
        end
        %find the first project in student's list 
        pj = stu_pref_list(si,find(stu_pref_list(si,:)~=0,1,'first'));
        if (sum(M(1,:) == pj) == proj_caps_list(pj))
            stu_pref_list(si,find(stu_pref_list(si,:)==pj)) = 0;
        % check if lecturer is over-subscribed
        else
            M(1,si) = pj;
            [lk,~] = find(lec_pref_list==pj);
            M(2,si) = lk; 
            valid_stu(si) = 0;
            % check if lecturer is over-subscribed
            if (sum(M(2,:)==lk) > lec_caps_list(lk))
                pz = find_worst_project(lec_rank_list,lk,M);
                sr = find(M(1,:) == pz);
                for i = 1:size(sr,2)
                    M(1,sr(i)) = 0;
                    M(2,sr(i)) = 0;
                    valid_stu(sr(i)) = 1;
                    stu_pref_list(sr(i),find(stu_pref_list(sr(i),:)==pz)) = 0;
                end
            end
            % check if lecturer is full
            if (sum(M(2,:)==lk) == lec_caps_list(lk))
                pz = find_worst_project(lec_rank_list, lk, M);
                %delete the project from student's list
                [~,pt] = find(lec_rank_list(lk,:) > lec_rank_list(lk,pz));
                for i = 1:size(pt,2)
                    stu_pref_list(stu_pref_list==pt(i)) = 0;
                end
            end
        end
    end
    f_cost = matching_cost(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list, M);
    f_time = toc;
end
