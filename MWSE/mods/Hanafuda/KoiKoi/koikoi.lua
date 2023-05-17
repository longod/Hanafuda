--- Koi-Koi types
local this = {}

---@enum KoiKoi.Calling
this.calling = {
    koikoi = 1, -- continue
    shobu = 2, -- finish
}

---@enum KoiKoi.Player
this.player = {
    you = 1,
    opponent = 2,
}

return this
