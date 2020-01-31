function [f] = check_blocking_pair(stu_rank_list,lec_rank_list,lec_caps_list,proj_caps_list,si,pj,M)
% A pair (si,pj) is a blocking pair in M iif 
%(1) si accept pj, and
%(2) si either is unassigned or strictly prefers pj to his assigned project in M
%(3) pj is undersubscribed and either
    %si in lk and lk prefer pj to M(si)
    %si not in lk and lk is under-subscribed
    %si not in lk and lk prefers pj to his worst project in M
%--------------------------------------------------------------    
%(1) si accept pj
rank_si_pj = stu_rank_list(si,pj);
f1 = (rank_si_pj > 0);
%
%(2) si either is unassigned or strictly prefers pj to his assigned hospital in M
pi = M(1,si);
if (pi > 0)
    rank_si_pi = stu_rank_list(si,pi);
else
    rank_si_pi = 0;
end
f2 = (pi == 0)||(rank_si_pj < rank_si_pi);
%
%(3) pj is undersubscribed and either
    %si in lk and lk prefer pj to M(si)
    %si not in lk and lk is under-subscribed
    %si not in lk and lk prefers pj to his worst project in M
f3 = (sum(M == pj) < proj_caps_list(pj))
    
    lki = lec_rank_list==pi;
    if (lki == lkj)
        f3 = lec_rank_list(lki,pj) < lec_rank_list(lki,pi);
    else
        ps = intersect(lec_caps_list(lki,:),M);
        for i = 1: size(ps,2)
            caps = caps + sum(M==ps(i));
        end
        f3 = caps < lec_caps_list(lki) || lec_rank_list(lki,pj) < lec_rank_list(lki,pi);
    end
end
%
%return the blocking pair definition 
f = f1 && f2 && f3;
end