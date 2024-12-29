--
-- StateMachine - a state machine
--
-- Credit: Colton Ogden
--
--

StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		render = function() end,
		update = function() end,
		enter = function() end,
		exit = function() end
	}
	self.states = states or {} -- [name] -> [function that returns states]
	self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
	assert(self.states[stateName],"Oops! State Doesn't Exist")
	print(stateName)
    print("Call stack:")
    local level = 0  -- Start from level 2 to skip the foo() and bar() calls
    while true do
        local info = debug.getinfo(level, "nSl")
        if not info then break end
        print(string.format("%d. %s:%d - %s", level - 1, info.source, info.currentline, info.name or "unknown"))
        level = level + 1
    end
    self.current:exit()
	self.current = self.states[stateName]()
	self.current:enter(enterParams)
	return self
end
StateMachine.switch=StateMachine.change

local callbacks={
	'update','render',
	'keyPressed','keyReleased',
	'mousePressed','mouseMoved','mouseReleased'
}

for i=1,#callbacks do
	StateMachine[callbacks[i]]=function(this,...)
		this.current[callbacks[i]](this.current,...)
	end
end
