using Distributed

function onplutoload(pr::Module)
    global is_pluto = true
    global PlutoRunner = pr
    println("Hello pluto!")
    
    responseadder = quote
        Core.eval(Main.Pluto, quote
            # responses[:PlutoUI_update] = (body, notebook; initiator=missing) -> begin
            #     @info "⚡ Update received!" body
            #     bound_sym = Symbol(body["sym"])
            #     new_val = body["val"]
        
            #     workspace = WorkspaceManager.get_workspace(notebook)
        
            #     token = take!(workspace.dowork_token)
            #     WorkspaceManager.eval_in_workspace(workspace, :($bound_sym = $new_val))
            #     put!(workspace.dowork_token, token)
        
            #     to_reeval = where_referenced(notebook, Set{Symbol}([bound_sym]))
            #     run_reactive!(notebook, to_reeval)
            # end

            addons["z.js"] = "console.log('z')"
            addons["⚡.js"] = $$(read(joinpath(PKG_ROOT_DIR, "assets", "PlutoUI.js"), String))
        end)
    end
    
    Distributed.remotecall_eval(Main, [1], responseadder)

    # TODO: return value shown as HTML
end

function onplutounload(_PlutoRunner::Module)
    println("Bye!")
end
