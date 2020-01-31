function [pz] = find_worst_project(lec_rank_list,lk,M)
%find the worst project, pz, assigned to lk in M
%
ps = [];
lec_pref_list = find(lec_rank_list(lk,:)~=0);
ps = intersect(lec_pref_list,M(1,:));
rank_lk_pi = zeros(1,size(ps,2));
for i = 1:size(ps,2)
    pi = ps(i);
    rank_lk_pi(i) = lec_rank_list(lk,pi);
end
[~,idx] = max(rank_lk_pi);
pz = ps(idx);
end
%==========================================================================