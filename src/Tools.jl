
"""
Check if the matrix is square...
"""
function checkmatrix(m::Matrix)
    (size(m,1) != size(m,2) || !(eltype(m) <: Number)) && error("Only square matrices of Numbers accepted, sorry!!!");
    for r in 1:size(m,1)
        for c in 1:size(m,2)
            if r == c
                m[r,c] != 0 && error("The diagonal must be filled by 0s");
            else
                m[r,c] != m[c,r] && error("The matrix must be symmetrical");
            end
        end
    end
    return m;
end

#################################################################################

"""
Return all the possibles combinations of these items
"""
function all_possible_rutes(items::Vector{T})::Vector{Vector{T}} where T

    #combs
    combs = Vector{Vector{T}}();

    #base case
    if length(items) == 2
        return push!(combs, [items[2],items[1]],[items[1],items[2]]);
    end

    #recursion block
    for i in 1:length(items)
        push!(combs, pushfirst!.(all_possible_rutes(copy_and_remove(items,i)),items[i])...);
    end

    return combs;
end

#################################################################################

"""
get the total cost of a given rute. The cost include the travel from the last city back to home.
"""
function rute_total_cost(cmatrix::Matrix{T}, rute::Vector{Int}) where T

    cost = 0;
    #add travel cost
    for t in 1:length(rute)-1
        cost += cmatrix[rute[t],rute[t+1]]; # central part of the trip
    end
    return cost + cmatrix[rute[end], 1]; # the way home
end

#################################################################################

"""
get the total costs of the given rutes. The cost of each rute include the travel from the last city back to home.
"""
function rutes_total_costs(cmatrix::Matrix{T}, rutes::Vector{Vector{Int}})::Vector where T
    costs = Vector();
    for rute in rutes
       push!(costs,rute_total_cost(cmatrix, rute)); # pushing all the rutes costs
    end
    return costs;
end

#################################################################################
"""
return the costs of each stretch of the rute...
"""
function rute_stretches_costs(cmatrix::Matrix{T}, rute::Vector{Int}) where T
   costs = zeros(T,length(rute));
    for t in 1:length(rute)-1
        costs[t] = cmatrix[rute[t],rute[t+1]]; # central part of the trip
    end
    costs[end] = cmatrix[rute[end],1];
    return costs;
end

#################################################################################

"""
return the rute of minimal cost.
"""
function pick_cheaper(cmatrix::Matrix{T}, rutes::Vector{Vector{Int}})::Vector{Int} where T
    return rutes[findmin(rutes_total_costs(cmatrix, rutes))[2]];
end

#################################################################################

function copy_and_remove(a::AbstractVector,i::Int)
    return lazy_remove!(copy(a),i);
end

#################################################################################

"""
Remove an element from the array. Warning, it is very probable that this
methos unsort the array!!!
"""
function lazy_remove!(n::AbstractArray, i::Int)
    if i == length(n)
        pop!(n);
    else
        n[i] = pop!(n);
    end
    return n;
end

#################################################################################

"""
Pick the rute from the bit matrix
"""
function pick_rute!(bm)
        r = Vector{Int}()
        bml = size(bm,1)
        d1 = 1;
        for i in 1:bml
            for d2 in 1:bml
                if bm[d1,d2] != 0
                    # println("Action in ", d1, " , ", d2);

                    #Save d1
                    push!(r,d1);
                    # println(d1, " pushed ", r);

                    #Clear
                    # println("Clearing")
                    # display(bm);
                    bm[d1,d2] = 0;
                    bm[d2,d1] = 0;
                    # println("Cleared")
                    # display(bm);

                    #Jump to d2
                    # println("Jumping to ", d2)
                    d1 = d2;

                    #break
                    # println("Break")
                    # println();
                    break;
                end
            end
        end
        return r;
end

#################################################################################

"""
Get the number of possible rutes given a number of cities to visit...
"""
function rutescount(ncities::T)::T where {T <: Integer}
    if ncities <= 1 error("ncities must be greater than 1")
    elseif ncities == 2 return 1
    else
        return (ncities - 1) * rutescount(ncities - 1)
    end
end

#################################################################################

function reverserute(r)
    rr = reverse(r);
    po = pop!(rr);
    return pushfirst!(rr,po);
end
