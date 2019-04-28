
struct CheapestRute
    rute::Vector{Int};
    rute_total_cost;
    rute_intervals_cost::Vector;
end

import Base.show;
function Base.show(io::IO, cr::CheapestRute)
    println("CheapestRute");
    println("rute: ", cr.rute);
    println("rute_total_cost: ", cr.rute_total_cost);
    println("rute_intervals_cost: ", cr.rute_intervals_cost);
end
