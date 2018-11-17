const breakpoints = [5]
const filename = "/home/kim/Documents/Experimental/juno.jl"

module Exec end

function nextbreakpoint()
    for line in @view lines[lineno:end]
        if (lineno in breakpoints)
            filter!(b -> b ≠ lineno, breakpoints)
            break
        else
            Exec.eval(Meta.parse(line))
            global lineno += 1
        end
    end
end
input = ""
const lines = open(filename) do file; [eachline(file)...] end
lineno = 1
while true
    (lineno == 1 || input == "n") && nextbreakpoint()
    lineno < length(lines) || break
    global input = readline()
end
