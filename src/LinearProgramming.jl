export solve_with_linear_programming;
using JuMP
using GLPK;

"""
Solve the TSP using linear programming for a given cost matrix!!!
Returns a CheapestRute struct with the rute, the total rute cost and the
cost per interval for the computed rute.
"""
function solve_with_linear_programming(costmatrix::Matrix{T})::CheapestRute where T
    checkmatrix(costmatrix);

    #matrix size
    ms = size(costmatrix,1);

    #Lineal Programming problem
    model = Model(with_optimizer(GLPK.Optimizer));

    #Desition variables
    @variable(model, x[1:ms,1:ms], Bin);

    #One go one left constraints
    @constraint(model, [j=1:ms], sum(x[i,j] for i in 1:ms) == 1);
    @constraint(model, [i=1:ms], sum(x[i,j] for j in 1:ms) == 1);

    #Subtour elimination constraints
    #One constraints
    @constraint(model, [i=1:ms], x[i,i] == 0);

    #Others
    @variable(model, u[1:ms]);
    rhv = ms - 1; #rigth hand value
    for i in 1:ms
        for j in 2:ms
            if i != j
                @constraint(model, u[i] - u[j] + ms*x[i,j] <= rhv)
            end
        end
    end

    #Objetive function
    @objective(model, Min, sum(costmatrix[i,j] * x[i,j] for i in 1:ms, j in 1:ms));
    optimize!(model);

    #Result
    bm = value.(x);

    #Reformating
    cheapest_rute = pick_rute!(bm);
    return CheapestRute(cheapest_rute, rute_total_cost(costmatrix, cheapest_rute), rute_stretches_costs(costmatrix, cheapest_rute));

end
