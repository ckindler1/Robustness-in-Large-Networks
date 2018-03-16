function [ N_red ] = merge_species( N, s_1, s_2 )
%MERGE reduces the network by removing species s

Y=N.Y;
Lam=N.Lam;
C=N.C;

%Merge species

Y(s_2,:)=Y(s_2,:)+Y(s_1,:);
Y(s_1,:)=[];

%Dealing with duplicate complexes

n=size(Y,2);
c=1:n;
i=1;
while i<size(c,2)
    for j=c(c>c(i))
        if Y(:,j)==Y(:,c(i))
            c(c==j)=[];
            C(c(i))={union(cell2mat(C(c(i))),cell2mat(C(j)))};
            Lam(c(i),:)=Lam(c(i),:)+Lam(j,:);
        end
    end
    i=i+1;
end

dups=setdiff(1:n,c);
Y(:,dups)=[];
Lam(dups,:)=[];
C(dups)=[];

%Dealing with duplicate reactions

r=1:size(Lam,2);
i=1;

while i<=size(r,2)
    if max(abs(Lam(:,r(i))))==0
        r(i)=[];
    else
        for j=r(r>r(i))
            if Lam(:,j)==Lam(:,r(i))
                r(r==j)=[];
            end
        end
        i=i+1;
    end
    
end

r_dups=setdiff(1:size(Lam,2),r);
Lam(:,r_dups)=[];


N_red.Y=Y;
N_red.C=C;
N_red.Lam=Lam;



