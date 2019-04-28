module Test
    import TravelerProblem;

    function rcmatrix(n, t::Type{<:Number})::Matrix{t}
        local rcm = Array{t,2}(undef,n,n);
        #Filling
        for i in 1:n
            for j in 1:i
                if i == j
                    rcm[i,j] = 0
                else
                    rcm[i,j] = rand(t);
                    rcm[j,i] = rcm[i,j]
                end

            end
        end
        return rcm;
    end
    rcmatrix(n) = rcmatrix(n,Int8);

    function trcmatrix(n, t::Type{<:Number};mc = 1, Mc = 5)
        or = collect(t,2:n);#ordered rutes
        rr = Vector{t}();#random rute
        push!(rr,1);
        for i in 2:n
            ri = rand(1:length(or));
            push!(rr,or[ri]);
            TravelerProblem.lazy_remove!(or,ri);
        end
        cm = repeat([t(Mc)],n,n);
        for i in 1:n
            cm[i,i] = 0;
        end
        for i in 1:n-1
           cm[rr[i],rr[i+1]] = mc;
           cm[rr[i+1],rr[i]] = mc;
        end
        cm[1,rr[end]] = mc;
        cm[rr[end],1] = mc;
        return (cm,rr);
    end

    trcmatrix(n) = trcmatrix(n,Int8)
end
