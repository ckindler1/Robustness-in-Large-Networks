function [ G ] = create_graph( N )
%create_graph vreates a graph for te network
G=digraph;


Lam=N.Lam;
r=size(Lam,2);
n=size(Lam,1);

G=addnode(G,n);

for i=1:r
    c_2=find(Lam(:,i)==1);
    c_1=find(Lam(:,i)==-1);
    
    if not(findedge(G,c_1,c_2))
        G=addedge(G,c_1,c_2);
    end

end
