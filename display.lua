local VERSION = C_AddOns.GetAddOnMetadata(..., "Version")
local TITAN_PLUGIN = "BuildDisplay"
local TITAN_BUTTON = "TitanPanel" .. TITAN_PLUGIN .. "Button"

local function GetButtonText()
  -- hero talent
  -- loadout

  local build_info = { }
  local spec_id = GetSpecialization()

  if spec_id then
    local spec_name = GetSpecializationInfo(spec_id)
    table.insert(build_info, spec_name)
  end

  return "Build: ", "BUILD INFORMATION HERE" -- FIXME
end

local function CreatePlugin()
  if _G[TITAN_BUTTON] then
    return
  end

  local frame = CreateFrame("Frame", nil, UIParent)
  local window = CreateFrame("Button", TITAN_BUTTON, frame, "TitanPanelTextTemplate")

  window.registry = {
    id = TITAN_PLUGIN,
    category = "Information",
    version = VERSION,
    menuText = "Build Information",
--    menuTextFunction = CreateMenu,
    buttonTextFunction = GetButtonText,
    tooltipTitle = "Build Information",
--    tooltipTextFunction = GetTooltipText,
    notes = "Display the current spec, build, and hero talents.",
    controlVariables = {
      ShowIcon = false,
      ShowLabelText = true,
--      ShowColoredText = true,
      DisplayOnRightSide = false,
    },
    savedVariables = {
    }
  }

  window:SetFrameStrata("FULLSCREEN")

  window:SetScript("OnShow", function(self)
    self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  end)

  window:SetScript("OnHide", function(self)
    self:UnregisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  end)

  window:SetScript("OnEvent", function(self, event, ...)
    local args = { ... }

    for i = 1, #args do
      print(args[i])
    end

    -- TitanPanelButton_UpdateButton(TITAN_PLUGIN)
  end)

  window:SetScript("OnClick", function(self, button)
    -- open talent menu?
    TitanPanelButton_OnClick(self, button)
  end)
end

CreatePlugin()
