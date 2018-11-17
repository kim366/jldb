const breakpoints = Int[4, 6]
const registeredvars = Symbol[]
const filename = "testscript.jl"

module Exec end

function evalandregister(line::String)
    ast = Meta.parse(line)
    typeof(ast) == Expr || return
    if length(ast.args) == 2 && typeof(ast.args[1]) == Symbol
        try
            Exec.eval(ast.args[1])
        catch e
            typeof(e) === UndefVarError && push!(registeredvars, ast.args[1])
        end
    end
    Exec.eval(ast)
end

function printvars()
    for var in registeredvars
        println(var, " = ", Exec.eval(var))
    end
end

function nextbreakpoint()
    for line in @view lines[lineno:end]
        if (lineno in breakpoints)
            filter!(b -> b ≠ lineno, breakpoints)
            break
        else
            evalandregister(line)
            global lineno += 1
        end
    end
end

input = ""
const lines = open(filename) do file; [eachline(file)...] end
lineno = 1

while true
    (lineno == 1 || input == "n") && nextbreakpoint()
    input == "p" && printvars()
    lineno <= length(lines) || break
    global input = readline()
end
