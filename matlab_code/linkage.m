function [ L ] =    linkage(N)
%LINKAGE finds the linkage classes for a network

Lam=N.Lam;

n=size(Lam,1);
r=size(Lam,2);

L=num2cell(1:n);
L_arr=1:n;

for i=1:r
    c_1=find(Lam(:,i)==1);
    c_2=find(Lam(:,i)==-1);
    L(L_arr(min(c_1,c_2)))={union(cell2mat(L(L_arr(c_1))),cell2mat(L(L_arr(c_2))))};
    L_arr(max(c_1,c_2))=L_arr(min(c_1,c_2));
end

dups=setdiff(1:n,L_arr);
L(dups)=[];