do
    local unitwind = require("unitwind").new({
        enabled = true,
        highlight = false,
    })
    unitwind:start("Koi-Koi Integration Test")

    unitwind:test("Run Game", function()
        unitwind:expect(function()
            local runner = require("Hanafuda.KoiKoi.runner").new(
                require("Hanafuda.KoiKoi.simplismBrain").new(),
                require("Hanafuda.KoiKoi.simplismBrain").new()
            )
            while runner:Run() do
            end
        end).NOT.toFail()
    end)

    unitwind:finish()
end
