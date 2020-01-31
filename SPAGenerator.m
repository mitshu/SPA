%======================================================================================
%By 
%Adopt from: Student-Project Allocation with preferences over Projects
%SPA Instances
%======================================================================================
function SPAGenerator()
clc
clear vars
clear all
close all
%
s = 5; %size of students
k = 1;
for l = 2%10:10:50  %size of lecturer  %the number of instances has the same (n,m,p1,p2)
for p1 = 0.4%0.1:0.1:0.8
    for p2 = 0.0%0.0:0.1:1.0
        i = 1;
        while (i <= k)
            S = rand(s,s);
            L = rand(l,s);
            %generate students' and lecturers' preference lists
            [~,stu_pref_list] = sort(S,2);
            [~,lec_pref_list] = sort(L,2);
            %generate an SPA instance
            [stu_rank_list,lec_rank_list,lec_caps_list,proj_caps_list] = make_rank_lists(stu_pref_list,lec_pref_list,p1,p2);
            %
            %if (~isempty(stu_rank_list)) 
                %create a random matching
                %M = make_random_matching(stu_rank_list,lec_rank_list,lec_caps_list);
                %
                %save preference matrices and the matching to file
                %filename = ['inputs\I(',num2str(s),',',num2str(l),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
                %save(filename,'res_rank_list','hos_rank_list','hos_caps_list','M');
                
                stu_rank_list
                fprintf('===============');
                %
                lec_rank_list
                fprintf('===============');
                %
                lec_caps_list
                proj_caps_list
                i = i + 1;
            %end
            end
        end
    end
end
end
%============================================================================================
function [stu_rank_list,lec_rank_list,lec_caps_list,proj_caps_list] = make_rank_lists(stu_pref_list,lec_pref_list,p1,p2)
%size of HRT instance
s = size(stu_pref_list,1);
l = size(lec_pref_list,1);
%
%1. generate an instance of HRP with incomplete lists
%
%generate randomly using a probability 
for i = 1:s
    %r - rank
    for r1 = 1:l
        if (rand() <= p1)
            stu_pref_list(i,r1) = 0;
        end  
    end
end
stu_pref_list
p = 1:s;
nprjs = s;
nlecs = l;
for i = 1:l
    nums = round(nprjs/nlecs);
    x = p(randperm(numel(p),nums));
    y = setdiff(lec_pref_list(i,:),x);
    for j = 1:size(y,2)
        pos = find(lec_pref_list(i,:)==y(j));
        lec_pref_list(i,pos) = 0;
    end
    p = setdiff(p,x);
    nprjs = nprjs - nums;
    nlecs = nlecs - 1;
end
%
%2. generate an instance of HRP with Ties, i.e. HRT
%
stu_rank_list = zeros(s,s);
lec_rank_list = zeros(l,s);
%check if any student has an empty preference list, discard the instance
for i = 1:s
    if ~any(stu_pref_list(i,:))
        stu_rank_list = [];
        return;
    end
end
%
%change to rank list and create ties in student' rank list
for i = 1:s
    %
    idx = find(stu_pref_list(i,:) ~=0,1,'first');
    stu_rank_list(i,stu_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:s
        if (stu_pref_list(i,j) > 0)
            if (rand() >= p2)
                cj = cj + 1;
            end
            stu_rank_list(i,stu_pref_list(i,j)) = cj;
        end
    end
end
%
%change to rank list and create ties in lecturer' rank list
for i = 1:l
    %
    idx = find(lec_pref_list(i,:) ~=0,1,'first');
    lec_rank_list(i,lec_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:s
        if (lec_pref_list(i,j) > 0)
            if (rand() >= p2)
                cj = cj + 1;
            end
            lec_rank_list(i,lec_pref_list(i,j)) = cj;
        end
    end
end
%
%3. generate capacity for lecturers
lec_caps_list = zeros(1,l);
for i = 1:l
    lec_caps_list(i) = randi(sum(lec_pref_list(i,:)~=0),1);
end    
%4. generate capacity for projects
for i = 1:s
    range = 0;
    range = numel(find(stu_pref_list==i));
    proj_caps_list(i) = randi(range, 1);
end
end
%==========================================================================