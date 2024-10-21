local VERSION = C_AddOns.GetAddOnMetadata(..., "Version")
local TITAN_PLUGIN = "BuildDisplay"
local TITAN_BUTTON = "TitanPanel" .. TITAN_PLUGIN .. "Button"

local function GetSpecName()
  local id = GetSpecialization()

  if not id then
    return "No Specialization"
  end

  local name = GetSpecializationInfo(id)
end

-- Handle no hero tree
local function GetHeroTreeName()
  local config_id = C_ClassTalents.GetActiveConfigID()
  local hero_tree_id = C_ClassTalents.GetActiveHeroTalentSpec()
  local hero_tree = C_Traits.GetSubTreeInfo(config_id, hero_tree_id)
  return hero_tree.name
end

-- Handle no loadout
local function GetLoadoutId()
  if PlayerSpellsFrame.TalentsFrame.LoadoutDropDown.GetSelectionID then
    return PlayerSpellsFrame.TalentsFrame.LoadoutDropDown:GetSelectionID()
  end

  local spec_id = PlayerUtil.GetCurrentSpecID()

  if spec_id then
    return C_ClassTalents.GetLastSelectedSavedConfigID(spec_id)
  end

  return C_ClassTalents.GetActiveConfigID()
end

local function GetLoadoutName()
  local loadout = C_Traits.GetConfigInfo(GetLoadoutId())
  return loadout.name
end

local function GetButtonText()
  local spec = GetSpecName()
  local hero_tree = GetHeroTreeName()
  local loadout = GetLoadoutName()


  return "Build: ", spec .. "|" .. hero_tree .. "|" .. loadout
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
    self:RegisterEvent("TRAIT_CONFIG_UPDATED")
  end)

  window:SetScript("OnHide", function(self)
    self:UnregisterEvent("TRAIT_CONFIG_UPDATED")
  end)

  window:SetScript("OnEvent", function(self, event, ...)
    if event == "TRAIT_CONFIG_UPDATED" then
      TitanPanelButton_UpdateButton(TITAN_PLUGIN)
    end
  end)

  window:SetScript("OnClick", function(self, button)
    -- open talent menu?
    TitanPanelButton_OnClick(self, button)
  end)
end

CreatePlugin()
