using TravelerProblem;
using Test;

@testset "TravelerProblem.jl" begin


        @testset "LP vs Bruteforce" begin
                #Compiling
                tm = TravelerProblem.Test.trcmatrix(4)[1];
                TravelerProblem.solve_with_linear_programming(tm);
                TravelerProblem.solve_with_very_brute_force(tm);
                println();
                printstyled("Testing LP vs Bruteforce",color = :green, bold = true);
                for i in 5:8
                        cm,rr = TravelerProblem.Test.trcmatrix(i);
                        println();
                        printstyled("Matrix dimension ($i,$i)\n", color = :blue)
                        println("Solving with linear programming:")
                        @time lpr = TravelerProblem.solve_with_linear_programming(cm)
                        println("Solving with very brute force:")
                        @time vbf = TravelerProblem.solve_with_very_brute_force(cm);
                        @test lpr.rute == rr || lpr.rute == TravelerProblem.reverserute(rr);
                        @test vbf.rute == rr || vbf.rute == TravelerProblem.reverserute(rr);
                end
                println();
        end

        @testset "LP with bigger matrices" begin

                println();
                printstyled("Testing LP for bigger matrices!!!",color = :green, bold = true);
                for i in 10:10:150
                        cm,rr = TravelerProblem.Test.trcmatrix(i, Int32);
                        println();
                        printstyled("Matrix dimension ($i,$i)\n", color = :blue)
                        println("Solving with linear programming:")
                        @time lpr = TravelerProblem.solve_with_linear_programming(cm)
                        @test lpr.rute == rr || lpr.rute == TravelerProblem.reverserute(rr);
                end
                println();

        end

end
