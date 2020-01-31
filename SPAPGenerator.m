%========================================================================================
%by Hoang Huu Viet
%ref. D.F.Manlove et al.: Student-Project Allocation with Preferences over Projects
%========================================================================================
clc
clear vars
close all
%number of students
for n = 500:50:1000
    %number of lecturers
    for m = round(n/10)
        %number of projects 
        for q = n/5
            %probability of incomplete in students' preference lists
            p = 0.5;
            %number of instances has the same (n,m,q,p)
            i = 1; k = 1;
            while (i <= k)
                %generate an SPA-P instance
                [lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list] = generator(n,m,q,p);
                 if (~isempty(stud_rank_list)) 
%                     %create a random matching
%                     [M] = make_random_matching(lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list);
%                     %
%                     sum(lect_caps_list)
                     %save rank matrices and the matching to file
                     filename = ['inputs\I(',num2str(n),',',num2str(m),',',num2str(q),',',num2str(p,'%.1f'),',',')-',num2str(i),'.mat'];
                     save(filename,'lect_rank_list','lect_caps_list','proj_caps_list','stud_rank_list');
%                         stud_rank_list             
%                         fprintf('===============');
%                         %                
%                         lect_rank_list
%                         %                 
%                         fprintf('===============');
%                         lect_caps_list
%                         proj_caps_list
                        i = i + 1;
            end
            end
        end
    end
end
%========================================================================================
function [lect_rank_list,lect_caps_list,proj_caps_list,stud_rank_list] = generator(n,m,q,p)
%m: number of lecturers
%q: number of projects
%n: number of students
%p: probability of projets in students' lists
%
%1.generate lecturers' projects whose sum of elements is equal to q
x = 1 + rand(m,1);
lect_proj_list = round(x/sum(x)*q);
lect_proj_list(1) = lect_proj_list(1) - sum(lect_proj_list) + q;
%
%generate lecturers' preference lists
q = sum(lect_proj_list);
lect_pref_list = zeros(m,q);
c = 1;
for i = 1:m
    for j = 1:lect_proj_list(i)
        lect_pref_list(i,j) = c;
        c = c + 1;
    end
end
%
%generate lecturers' rank lists
lect_rank_list = zeros(m,q);
for i = 1:m
    for j = 1:q
        if (lect_pref_list(i,j) > 0)
            lect_rank_list(i,lect_pref_list(i,j)) = j;
        end
    end
end
%
%2. the total capacities of the projects
total_cj = round(1.1*n);
%total_cj is randomly distributed amongst the projects
x = 1 + rand(1,q);
proj_caps_list = round(x/sum(x)*total_cj);
proj_caps_list(1) = proj_caps_list(1) - sum(proj_caps_list) + total_cj;
%
%3. the capacity for each lecturer lk is chosen randomly to lie between 
%the highest capacity of the projects offered by lk and the sum of the
%capacities of the projects that lk offers.
%
lect_caps_list = zeros(m,1);
for i = 1:m
    pj = find(lect_rank_list(i,:) > 0);
    if isempty(pj)
        stud_rank_list = [];
        return;
    end
    d1 = max(proj_caps_list(pj));
    d2 = sum(proj_caps_list(pj));
    lect_caps_list(i) = randi([d1,d2],1,1); %d2;
end
%
%4. generate students' preference lists with probability of p 
y = rand(n,q);
[~,stud_pref_list] = sort(y,2);
for i = 1:n
    for j = 1:q
        if (rand() <= p)
            %delete project j from student ith list
            stud_pref_list(i,j) = 0;
        end
    end
end
%check if any student has an empty preference list, discard the instance
for i = 1:n
    if ~any(stud_pref_list(i,:))
        stud_rank_list = [];
        return;
    end
end
%generate students' rank lists
stud_rank_list = zeros(n,q);
for i = 1:n
    idx = find(stud_pref_list(i,:) ~=0,1,'first');
    stud_rank_list(i,stud_pref_list(i,idx)) = 1;
    cj = 1;
    for j = idx+1:q
        if (stud_pref_list(i,j) > 0)
            cj = cj + 1;
            stud_rank_list(i,stud_pref_list(i,j)) = cj;
        end
    end
end
end
%========================================================================================




