function op = genAlgRoughFitEval(x, L_x, L_z, goal, seed)
    n = x(1);
    W_k = x(2);
    W_l = x(3);
    gamm = x(4);
    beta = x(5);

    try
        rsurf = roughSurfClass(n, W_l, W_k, gamm, beta, L_x, L_z, seed=seed);
        rough = rsurf.evaluate();

        % fitness evaluation function -- mean relative absolute error
        op = mean( [ abs((rough(1) - goal(1))/goal(1)) ...
                     abs((rough(2) - goal(2))/goal(2)) ...
                     abs((rough(3) - goal(3))/goal(3)) ...
                     abs((rough(4) - goal(4))/goal(4)) ...
                     abs((rough(5) - goal(5))/goal(5)) ...
                     abs((rough(6) - goal(6))/goal(6)) ], "all" );
    catch
        op = NaN;
    end
end
