function [f_time,f_cost,M] = SPA_P_approx_promotion(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list)
n = size(stu_rank_list,1);
m = size(lec_rank_list,1);
c = size(proj_caps_list,2);
M = zeros(2,n);
stu_pref_list = zeros(n,c);
lec_pref_list = zeros(m,c);
tic;
% student's state(promoted or promoted)
promoted = zeros(1,n);
% valid student
valid_stu = ones(1,n);

%get stu_pref_list from stu_rank_list
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
        if (M(1,si)==0 && sum(stu_pref_list(si,:)==0)==c && promoted(si) == 0)  
            promoted(si) = 1;
            valid_stu(si)= 1;
            restore = find(stu_rank_list(si,:)~=0);
            stu_pref_list(si,(1:size(restore,2))) = restore;
        end
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
        [lk,~] = find(lec_pref_list==pj);
        pz = find_worst_project(lec_rank_list,lk,M);
        if isempty(pz)
            A = n;
        else
            A = lec_rank_list(lk,pz);
        end
        unpromoted_studs = find(promoted==0);
        if (sum(M(1,:) == pj) == proj_caps_list(pj) || sum(M(2,:)==lk) == lec_caps_list(lk) && pj == pz)
            studs_pj = find(M(1,:)==pj);
            unpromoted_studs_pj = intersect(studs_pj,unpromoted_studs);
            if (promoted(si) == 0) || size(unpromoted_studs_pj,2) == 0 
                stu_pref_list(si,find(stu_pref_list(si,:)==pj)) = 0;
            else
                rand_stu = unpromoted_studs_pj(randi(numel(unpromoted_studs_pj)));
                M(1,rand_stu) = 0;
                M(2,rand_stu) = 0;
                stu_pref_list(rand_stu,find(stu_pref_list(rand_stu,:)==pz)) = 0;
                valid_stu(rand_stu) = 1;
                M(1,si) = pj;
                M(2,si) = lk;
                valid_stu(si) = 0;
            end
        % check if lecturer is over-subscribed
        elseif sum(M(2,:)==lec_caps_list(lk)) && A < lec_rank_list(lk,pj)
            stu_pref_list(si,find(stu_pref_list(si,:)==pj)) = 0;
        else
            M(1,si) = pj;
            M(2,si) = lk; 
            valid_stu(si) = 0;
            % check if lecturer is over-subscribed
            if (sum(M(2,:)==lk) > lec_caps_list(lk))
                pz = find_worst_project(lec_rank_list,lk,M);
                pz_stu = find(M(1,:)==pz);
                unpromoted_studs = find(promoted==0);
                unpromoted_studs_pz = intersect(pz_stu,unpromoted_studs);
                if size(unpromoted_studs_pz,2) > 0
                    rand_stu = unpromoted_studs_pz(randi(numel(unpromoted_studs_pz)));
                else
                    rand_stu = pz(randi(numel(pz)));
                end
                M(1,rand_stu) = 0;
                M(2,rand_stu) = 0;
                valid_stu(rand_stu) = 1;
                stu_pref_list(rand_stu,find(stu_pref_list(rand_stu,:)==pz)) = 0;
            end
        end
    end
    f_cost = matching_cost(stu_rank_list, lec_rank_list, lec_caps_list, proj_caps_list, M);
    f_time = toc;
end
