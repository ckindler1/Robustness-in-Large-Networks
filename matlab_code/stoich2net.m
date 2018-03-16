function [ N ] = stoich2net( S )

m=size(S,1);
r=size(S,2);

%% Finding Complexes

S_plus=max(S,0);
S_minus=max(-S,0);

S_long=[S_plus,S_minus];

c=zeros(2*r,1);
k=1;
c(1)=k;

for i=2:2*r
    for j=1:i-1
        if S_long(:,j)==S_long(:,i)
            c(i)=c(j);
        end
    end
    if c(i)==0
        k=k+1;
        c(i)=k;
    end
end

n=max(c);

%% Building matricies

Lam=zeros(n,r);
Y=zeros(m,n);
k=1;

for i=1:2*r
    if c(i)==k
        Y(:,k)=S_long(:,i);
        k=k+1;
    end
end

for i=1:r
    Lam(c(i),i)=1;
    Lam(c(r+i),i)=-1;
end
    
N.Y=Y;
N.Lam=Lam;
N.C=num2cell(1:n);




