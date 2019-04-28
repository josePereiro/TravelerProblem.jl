export get_all_rutes_from_home;
export solve_with_very_brute_force;

"""
Get all the possibles ways to visit all the cities from home.
"""
function get_all_rutes_from_home(ncities; home::Int = 1)::Vector{Vector{Int}}
    return pushfirst!.(all_possible_rutes(copy_and_remove(collect(1:ncities),home)), home);
end

"""
Solve teh TSP using brute force. It finds all the rutes and then pick the cheapest.
Returns a CheapestRute struct with the rute, the total rute cost and the
cost per interval for the computed rute.
"""
function solve_with_very_brute_force(costmatrix::Matrix{T}; home::Int = 1)::CheapestRute where T
    checkmatrix(costmatrix);
    cheapest_rute = pick_cheaper(costmatrix, get_all_rutes_from_home(size(costmatrix,1); home = home));
    return CheapestRute(cheapest_rute, rute_total_cost(costmatrix, cheapest_rute), rute_stretches_costs(costmatrix, cheapest_rute));
end
