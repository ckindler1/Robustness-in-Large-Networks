function [ P_throughout ] = get_potential_faster(N)
%GET_POTENTIAL_FASTER finds an approximation of d' for each reduction.


m=size(N.Y,1);
n=size(N.Y,2);

L=linkage(N);

P_throughout=zeros(m);

Y=N.Y;

comp=10;

for c_1=1:n
    for c_2=1:c_1-1
        
        y=Y(:,c_1)-Y(:,c_2);
        y_supp=find(y);
        
        if nnz(y)==0
            disp(0)
        end
        
        if nnz(y)==1
            s=y_supp(1);
            P_throughout(s,s)=P_throughout(s,s)+1;
        end
        
        if nnz(y)==2
            s_1=y_supp(1);
            s_2=y_supp(2);
            P_throughout(s_1,s_2)=P_throughout(s_1,s_2)+1;
            P_throughout(s_2,s_1)=P_throughout(s_2,s_1)+1;
        end
    end
    
    if c_1/n>comp/100
        fprintf('%d%% done\n',comp);
        comp=comp+10;
    end
end

