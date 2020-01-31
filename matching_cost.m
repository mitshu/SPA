function [f] = matching_cost(stud_rank_list, lect_rank_list, lect_caps_list, proj_caps_list, M)
n = size(stud_rank_list,1);
m = size(lect_rank_list,1);
c = size(proj_caps_list,2);
nbp = 0;
ns = sum(M(1,:)==0); 
X = [];
for si = 1:n
    pjs = find(stud_rank_list(si,:)~=0);
    for i = 1:size(pjs,2)
        pj = pjs(i);
        if(check_blocking_pairT(stud_rank_list,lect_rank_list,lect_caps_list,proj_caps_list,si,pj,M)==true)
            nbp = nbp + 1;
            X(end+1,:) = [si,M(1,si),pj];
        end
    end
end
X;
f = nbp + ns;
end