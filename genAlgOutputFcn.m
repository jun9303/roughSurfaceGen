function [state,options,optchanged] = genAlgOutputFcn(options,state,flag)
    genAlgPath = './genAlg';
    optchanged = false;
    switch flag
        case 'init'
            if ~isfolder(genAlgPath)
                mkdir(genAlgPath)
            end
            delete([genAlgPath '/' '*.txt'])
    end
    writematrix(state.Population,[genAlgPath '/' 'CurrentPopulation.txt'],'Delimiter',' ');
    writematrix(state.Score,[genAlgPath '/' 'CurrentPopulationScore.txt'],'Delimiter',' ');
    writematrix(state.Population,[genAlgPath '/' 'TotalPopulation.txt'],'Delimiter',' ','WriteMode','append');
    writematrix(state.Score,[genAlgPath '/' 'TotalPopulationScore.txt'],'Delimiter',' ','WriteMode','append');
end