function [ P_within, P_throughout ] = get_potential(N)
%GET_POTENTIAL finds the exact values of d' and e' for each reduction.
%Extremely slow

m=size(N.Y,1);
n=size(N.Y,2);

L=linkage(N);

P_within=zeros(m);
P_throughout=zeros(m);

for s_1=1:m
    for s_2=1:s_1
        Y=N.Y;
        Y([s_1,s_2],:)=[];
        c=1:n;
        i=1;
        while i<size(c,2)
            for j=c(c>c(i))
                if Y(:,j)==Y(:,c(i))
                    c(c==j)=[];
                    P_throughout(s_1,s_2)=P_throughout(s_1,s_2)+1;
                    for l=L
                        if ismember(i,cell2mat(l))
                            if ismember(j,cell2mat(l))
                                P_within(s_1,s_2)=P_within(s_1,s_2)+1;
                            end
                            break
                        elseif ismember(j,cell2mat(l))
                            break
                        end
                    end
                end
            end
            i=i+1;
        end
        P_within(s_2,s_1)=P_within(s_1,s_2);
        P_throughout(s_2,s_1)=P_throughout(s_1,s_2);
    end
    disp(s_1)
end

