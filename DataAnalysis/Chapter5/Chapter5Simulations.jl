#=
Author: Raquel Montero Estebaranz
Date: 04.06.2024
Description: The following is the code use for generating the three grammar competition simulations that appear in Chapter 5 of the thesis entitled "Mood alternations: a synchronic and diachronic study of negated complement clauses".
Language: Julia 1.9.3.
Acknowledgements: The code is heavily based on Kauhanen (2023)'s lectures, if you (re)use this code please consider acknowledging the work of this author as well:
Kauhanen, Henri (2023). Language dynamics. Lecture Notes, University of Konstanz.
=#


# Creating a variational learner type:
mutable struct VL
    w0::Float64        # weight of G0
    w1::Float64        # weight of G1
    w2::Float64        # weight of G2 
    gamma::Float64     # learning rate
end


# Function to randomly choose a grammar with wich to parse the next sentence:
using StatsBase
function pick_grammar(x::VL)
    sample(["G0","G1","G2"], Weights([x.w0, x.w1, x.w2]))
end


# Define a random stationary enviroment: 
struct SRE
    c0::Float64
    c1::Float64
    c2::Float64
end

# Making SRE  broadcastable:
Base.broadcastable(x::SRE) = Ref(x)

# Sample a string:
function sample_sentence(x::SRE)
    sample(["c0", "c1","c2"], Weights([x.c0, x.c1, x.c2]))
end

# Steping function:
function step!(x::VL, y::SRE)
    s = sample_sentence(y)
    g = pick_grammar(x)

    if g=="G1" && s=="c1" 
        punish!(x, g)
    elseif g=="G1" && s!="c1"
        reward!(x, g)
    elseif g=="G2" && s=="c2" 
        punish!(x, g)
    elseif g=="G2" && s!="c2"
        reward!(x, g)
    elseif g=="G0" && s=="c0" 
        punish!(x,g)
    elseif g=="G0" && s!="c0"
        reward!(x,g)
    end
    return [x.w0, x.w1, x.w2]
end



# Punishing function:
function punish!(x::VL, g::String)
    if g == "G0" # Punishing G0
        x.w0 = (1-x.gamma)*x.w0 
        x.w1 = (x.gamma/2) + (1 - x.gamma)*x.w1
        x.w2 = (x.gamma/2) + (1 - x.gamma)*x.w2
    elseif g == "G1" # Punishing G1 
        x.w1 = (1-x.gamma)*x.w1
        x.w0 = (x.gamma/2) + (1 - x.gamma)*x.w0 
        x.w2 = (x.gamma/2) + (1 - x.gamma)*x.w2 
    elseif g== "G2" 
        x.w2 = (1-x.gamma)*x.w2
        x.w0 = (x.gamma/2) + (1 - x.gamma)*x.w0
        x.w1 = (x.gamma/2) + (1 - x.gamma)*x.w1
    end
end


# Reward function:
function reward!(x::VL, g::String)
    if g == "G0" 
        x.w0 = x.w0 + x.gamma*(1-x.w0) 
        x.w1 = (1-x.gamma)*x.w1 
        x.w2 = (1-x.gamma)*x.w2 
    elseif g == "G1" 
        x.w1 = x.w1 + x.gamma*(1-x.w1)
        x.w0 = (1-x.gamma)*x.w0   
        x.w2 = (1-x.gamma)*x.w2   
    elseif g =="G2" 
        x.w2 = x.w2 + x.gamma*(1-x.w2) 
        x.w0 = (1-x.gamma)*x.w0
        x.w1 = (1-x.gamma)*x.w1
    end
end


# Intergenerational function: 
function intergeneration(a01,a02,a10,a12,a20,a21,n,r,generations) 
    # values per generation: 
    trajectory = zeros(generations+1, 3) #matrix of zeros
    # initial state:
    EndState = [0.80, 0.10, 0.10]
    # Adding the initial stage to the first row of the matrix: 
    trajectory[1,:] = EndState
    # loop to calculate the means of each grammar
    for t in 1:generations
        #create the learning enviroment:
        enviroment = SRE(a01*EndState[2] + a02*EndState[3],
                         a12*EndState[3] + a10*EndState[1],
                         a21*EndState[2]+ a20*EndState[1])
        #create current population:
        pop = [VL(0.33,0.33,0.33,0.01) for i in 1:n] 

        learning = [step!.(pop, enviroment) for t in 1:r ]
        learningMatrix = reduce(vcat,transpose.(learning)) #transform into a matrix
        # get the final stage of that generation:
        finalState = learningMatrix[end, :]

        #calculate the means value for each grammar of the final State:
        meanw0 = mean(getindex.(finalState,1))
        meanw1 = mean(getindex.(finalState,2))
        meanw2 = mean(getindex.(finalState,3))

        # add the initial state to the matrix:
        trajectory[t+1,:] = [meanw0, meanw1, meanw2]

        # store the mean value in the initial state for the next generation to use:
        EndState = [meanw0, meanw1, meanw2]
        
    end

    return trajectory

end


# SEMIFACTIVES:
# Simulation 1:
change = intergeneration(0.5, # a01
                         0.2, # a02
                         0.2, # a10
                         0.0, # a12
                         0.4,   # a20
                         0.4, # a21
                         100, # n
                         10_000, # r
                         20     # generations
                         )

# Calculating wheather condition 5.17 is satisfied: 
# condition 5.17 --> a12 + a10 < 1/((1/a21)+(1/a01))
condition = 0 + 0.2 < 1/((1/0.4)+(1/0.5))

#ploting the results: 
using Plots
using LaTeXStrings

plot_font = "Computer Modern"
default(fontfamily=plot_font)
scalefontsizes(1.1)

#annotation: 
point_to_annotate = (15, 0.7)
text_condition = L"Condition (5.17) = %$condition"


plot(1:21, change[:, 1],width=2, dpi=600,linestyle = :dash,
    legend = :outertopright,
        lc=:orange,
        label = "G0", 
        xlabel = "Generations", 
        ylabel = "Grammar's Probability",
        title = "3 Grammar Competition: Semi-factives"
    )
plot!(1:21, change[:, 2],  lc=:blue, label="G1",
             width=2, 
             linestyle = :dashdot)
plot!(1:21, change[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)
annotate!((point_to_annotate[1], point_to_annotate[2], text_condition))

# Simulation 2: 
change2 = intergeneration(0.3, # a01
                         0.6, # a02
                         0.2, # a10
                         0.0, # a12
                         0.4,   # a20
                         0.9, # a21
                         100, # n
                         10_000, # r
                         20     # generations
                         )

# condition 5.17 --> a12 + a10 < 1/((1/a21)+(1/a01))
condition2 = 0 + 0.2 < 1/((1/0.9)+(1/0.3))

#annotation: 
point_to_annotate2 = (15, 0.7)
text_condition2 = L"Condition (5.17) = %$condition2"


plot(1:21, change2[:, 1],width=2, dpi=600,linestyle = :dash,
    legend = :outertopright,
        lc=:orange,
        label = "G0", 
        xlabel = "Generations", 
        ylabel = "Grammar's Probability",
        title = "3 Grammar Competition: Semi-factives"
    )
plot!(1:21, change2[:, 2],  lc=:blue, label="G1",
             width=2, 
             linestyle = :dashdot)
plot!(1:21, change2[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)
annotate!((point_to_annotate2[1], point_to_annotate2[2], text_condition2))

# Simulation 3:
change3 = intergeneration(0.5, # a01
                         0.9, # a02
                         0.45, # a10
                         0.0, # a12
                         0.4,   # a20
                         0.01, # a21
                         100, # n
                         10_000, # r
                         20     # generations
                         )

# condition 5.17 --> a12 + a10 < 1/((1/a21)+(1/a01))
condition3 = 0 + 0.45 < 1/((1/0.01)+(1/0.5))

#annotation: 
point_to_annotate3 = (15, 0.6)
text_condition3 = L"Condition (5.17) = %$condition3"


plot(1:21, change3[:, 1],width=2, dpi=600,linestyle = :dash,
    legend = :outertopright,
        lc=:orange,
        label = "G0", 
        xlabel = "Generations", 
        ylabel = "Grammar's Probability",
        title = "3 Grammar Competition: Semi-factives"
    )
plot!(1:21, change3[:, 2],  lc=:blue, label="G1",
             width=2, 
             linestyle = :dashdot)
plot!(1:21, change3[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)
annotate!((point_to_annotate3[1], point_to_annotate3[2], text_condition3))

# Simulation 4:
change4 = intergeneration(0.5, # a01
                         0.3, # a02
                         0.3, # a10
                         0.0, # a12
                         0.4,   # a20
                         0.4, # a21
                         100, # n
                         10_000, # r
                         20     # generations
                         )

# condition 5.17 --> a12 + a10 < 1/((1/a21)+(1/a01))
condition4 = 0 + 0.3 < 1/((1/0.4)+(1/0.5))

#annotation: 
point_to_annotate4 = (15, 0.7)
text_condition4 = L"Condition (5.17) = %$condition4"


plot(1:21, change4[:, 1],width=2, dpi=600,linestyle = :dash,
    legend = :outertopright,
        lc=:orange,
        label = "G0", 
        xlabel = "Generations", 
        ylabel = "Grammar's Probability",
        title = "3 Grammar Competition: Semi-factives"
    )
plot!(1:21, change4[:, 2],  lc=:blue, label="G1",
             width=2, 
             linestyle = :dashdot)
plot!(1:21, change4[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)
annotate!((point_to_annotate4[1], point_to_annotate4[2], text_condition4))


# NONFACTIVES
# Simulation 1:

changeNF1 = intergeneration(0.6, # a01
                         0.6, # a02
                         0.2, # a10
                         1, # a12
                         0.2,   # a20
                         1, # a21
                         100, # n
                         10_000, # r
                         20     # generations
                         )
plot(1:21, changeNF1[:, 1],width=2, dpi=600,linestyle = :dash,
                         legend = :outertopright,
                             lc=:orange,
                             label = "G0", 
                             xlabel = "Generations", 
                             ylabel = "Grammar's Probability",
                             title = "3 Grammar Competition: Non-factives"
                         )
plot!(1:21, changeNF1[:, 2],  lc=:blue, label="G1",
                                  width=2, 
                                  linestyle = :dashdot)
plot!(1:21, changeNF1[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)

# Simulation 2:
changeNF2 = intergeneration(0.2, # a01
                         0.6, # a02
                         0.6, # a10
                         1, # a12
                         0.2,   # a20
                         1, # a21
                         100, # n
                         10_000, # r
                         20     # generations
                         )
plot(1:21, changeNF2[:, 1],width=2, dpi=600,linestyle = :dash,
                         legend = :outertopright,
                             lc=:orange,
                             label = "G0", 
                             xlabel = "Generations", 
                             ylabel = "Grammar's Probability",
                             title = "3 Grammar Competition: Non-factives"
                         )
plot!(1:21, changeNF2[:, 2],  lc=:blue, label="G1",
                                  width=2, 
                                  linestyle = :dashdot)
plot!(1:21, changeNF2[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)

# Simulation 3:
changeNF3 = intergeneration(0.6, # a01
                         0.2, # a02
                         0.2, # a10
                         1, # a12
                         0.6,   # a20
                         1, # a21
                         100, # n
                         10_000, # r
                         20     # generations
                         )
plot(1:21, changeNF3[:, 1],width=2, dpi=600,linestyle = :dash,
                         legend = :outertopright,
                             lc=:orange,
                             label = "G0", 
                             xlabel = "Generations", 
                             ylabel = "Grammar's Probability",
                             title = "3 Grammar Competition: Non-factives"
                         )
plot!(1:21, changeNF3[:, 2],  lc=:blue, label="G1",
                                  width=2, 
                                  linestyle = :dashdot)
plot!(1:21, changeNF3[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)

# Simulation 4:
changeNF4 = intergeneration(0.2, # a01
                         0.2, # a02
                         0.2, # a10
                         1, # a12
                         0.2,   # a20
                         1, # a21
                         100, # n
                         10_000, # r
                         20     # generations
                         )
plot(1:21, changeNF4[:, 1],width=2, dpi=600,linestyle = :dash,
                         legend = :outertopright,
                             lc=:orange,
                             label = "G0", 
                             xlabel = "Generations", 
                             ylabel = "Grammar's Probability",
                             title = "3 Grammar Competition: Non-factives"
                         )
plot!(1:21, changeNF4[:, 2],  lc=:blue, label="G1",
                                  width=2, 
                                  linestyle = :dashdot)
plot!(1:21, changeNF4[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)


# Simulation 5: CONTACT
# intergenerational function: 

function intergeneration2(a01,a02,a10,a12,a20,a21,
                            a01prime,a02prime,a10prime,a12prime,a20prime,a21prime,
                            n,r,generationsContact,generationsNoContact
                        ) 
                # values per generation: 
                trajectory = zeros(generationsContact+generationsNoContact+1, 3) #matrix of zeros
                # initial state:
                EndState = [0.60, 0.10, 0.10]
                # Adding the initial stage to the first row of the matrix: 
                trajectory[1,:] = EndState
                # loop to calculate the means of each grammar
                for t in 1:generationsContact
                    #create the learning enviroment:
                    enviroment = SRE(a01*EndState[2] + a02*EndState[3],
                        a12*EndState[3] + a10*EndState[1],
                        a21*EndState[2]+ a20*EndState[1])

                    #create current population:
                    pop = [VL(0.33,0.33,0.33,0.1) for i in 1:n] #the initial state of the population is always the same

                    learning = [step!.(pop, enviroment) for t in 1:r ]
                    learningMatrix = reduce(vcat,transpose.(learning)) #transform into a matrix
                    # get the final stage of that generation:
                    finalState = learningMatrix[end, :]

                    #calculate the means value for each grammar of the final State:
                    meanw0 = mean(getindex.(finalState,1))
                    meanw1 = mean(getindex.(finalState,2))
                    meanw2 = mean(getindex.(finalState,3))

                    # add the initial state to the matrix:
                    trajectory[t+1,:] = [meanw0, meanw1, meanw2]
                    # store the mean value in the initial state for the next generation to use:
                    EndState = [meanw0, meanw1, meanw2]
                end

                for t in 1:generationsNoContact
                    #create the learning enviroment:
                    enviroment = SRE(a01prime*EndState[2] + a02prime*EndState[3],
                        a12prime*EndState[3] + a10prime*EndState[1],
                        a21prime*EndState[2]+a20prime*EndState[1]
                        )
                    #create current population:
                    pop = [VL(0.33,0.33,0.33,0.1) for i in 1:n] #the initial state of the population is always the same

                    learning = [step!.(pop, enviroment) for t in 1:r ]
                    learningMatrix = reduce(vcat,transpose.(learning)) #transform into a matrix
                    # get the final stage of that generation:
                    finalState = learningMatrix[end, :]

                    #calculate the mean value for each grammar of the final State:
                    meanw0 = mean(getindex.(finalState,1))
                    meanw1 = mean(getindex.(finalState,2))
                    meanw2 = mean(getindex.(finalState,3))

                    # add the initial state to the matrix:
                    trajectory[generationsContact+t+1,:] = [meanw0, meanw1, meanw2]
                    # store the mean value in the initial state for the next generation to use:
                    EndState = [meanw0, meanw1, meanw2]
                end

            return trajectory

end

change = intergeneration2(0.7, # a01
                         0.2, # a02
                         0.3, # a10
                         0.5, # a12
                         0.7, #a20
                         1, # a21
                         0.7, # a01prima
                         0.7, # a02prima
                         0.2, # a10prima
                         1, # a12prima
                         0.2, # a20prima
                         0.5, # a21prima
                         100, # n
                         1_000, # r
                         10,     # generations contact
                         10 # generations without contact
                         )
plot(1:21, change[:, 1],width=2, dpi=600,linestyle = :dash,
                         lc=:orange,
                         label = "G0", 
                         xlabel = "Generations", 
                         ylabel = "Grammar's Probability",
                         title = "Non-factives with changing Advantages"
                     )
plot!(1:21, change[:, 2],  lc=:blue, label="G1",
                              width=2, 
                              linestyle = :dashdot)
plot!(1:21, change[:, 3],  lc=:green, label="G2", width=2)
ylims!(0,1)
                 
