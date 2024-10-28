module ABMModel

using Agents, Images

export create_model, agent_step!, run_model

mutable struct PixelAgent <: AbstractAgent
    id::Int
    position::Tuple{Int, Int}
    rgb_value::RGB
end

function create_model(rgb_image)
    height, width = size(rgb_image)
    space = GridSpace((width, height), periodic = false)
    
    model = AgentBasedModel(PixelAgent, space)

    for y in 1:height, x in 1:width
        add_agent!(PixelAgent((x, y), rgb_image[y, x]), model)
    end

    return model
end

function agent_step!(agent, model)
    agent.rgb_value = Distortion.distort_pixel(agent.rgb_value, HSV(agent.rgb_value))
end

function run_model(model, steps)
    for _ in 1:steps
        step!(model, agent_step!, model.agents)
    end
end

end