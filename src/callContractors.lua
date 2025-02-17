--- ${title}

---@author ${author}
---@version r_version_r
---@date 18/03/2021

---@diagnostic disable: lowercase-global

InitRoyalMod(Utils.getFilename("rmod/", g_currentModDirectory))
InitRoyalUtility(Utils.getFilename("utility/", g_currentModDirectory))

---@class CallContractors : RoyalMod
CallContractors = RoyalMod.new(r_debug_r, false)

function CallContractors:initialize()
    self.gameEnv["g_callContractors"] = self
    ---@type CallContractors
    g_callContractors = self

    self.savegameFilename = "callContractors.xml"

    self.guiDirectory = Utils.getFilename("gui/", self.directory)

    Utility.overwrittenFunction(Player, "new", PlayerExtension.new)
    if Player.showCallContractorsActionEvent == nil then
        Player.showCallContractorsActionEvent = PlayerExtension.showCallContractorsActionEvent
    end

    self.moneyType = MoneyType.getMoneyType("wagePayment", "finance_cc_contractorsPayment")

    source(Utils.getFilename("contractTypes/contractType.lua", self.directory))
    source(Utils.getFilename("contractTypes/sowingContractType.lua", self.directory))
    source(Utils.getFilename("contractTypes/sellingGoodsContractType.lua", self.directory))

    source(Utils.getFilename("contracts/encapsulation/contractProposal.lua", self.directory))
    source(Utils.getFilename("contracts/encapsulation/signedContract.lua", self.directory))

    source(Utils.getFilename("contracts/contract.lua", self.directory))
    source(Utils.getFilename("contracts/cultivatingContract.lua", self.directory))
    source(Utils.getFilename("contracts/plowingContract.lua", self.directory))
    source(Utils.getFilename("contracts/sowingContract.lua", self.directory))
    source(Utils.getFilename("contracts/sellingGoodsContract.lua", self.directory))
    source(Utils.getFilename("contracts/subsoilingContract.lua", self.directory))
    source(Utils.getFilename("contracts/limeSpreadingContract.lua", self.directory))

    ---@type ContractType[]
    self.CONTRACT_TYPES = {}
    self.CONTRACT_TYPES[1] = ContractType.new(1, PlowingContract, "plowing_contract_type", g_i18n:getText("cc_job_type_plowing"))
    self.CONTRACT_TYPES[2] = ContractType.new(2, CultivatingContract, "cultivating_contract_type", g_i18n:getText("cc_job_type_cultivating"))
    self.CONTRACT_TYPES[3] = ContractType.new(3, SubsoilingContract, "subsoiling_contract_type", g_i18n:getText("cc_job_type_subsoiling"))
    self.CONTRACT_TYPES[4] = ContractType.new(4, LimeSpreadingContract, "lime_spreading_contract_type", g_i18n:getText("cc_job_type_limeSpreading"))
    self.CONTRACT_TYPES[5] = SowingContractType.new(5, SowingContract, "sowing_contract_type", g_i18n:getText("cc_job_type_sowing"))
    self.CONTRACT_TYPES[6] = SellingGoodsContractType.new(6, SellingGoodsContract, "selling_contract_type", g_i18n:getText("cc_job_type_selling_goods"))

    self.contractsManager = ContractsManager:load()

    ---@type ContractsManager
    g_contractsManager = self.contractsManager

    g_gui:loadProfiles(self.guiDirectory .. "guiProfiles.xml")

    self.gui = g_gui:loadGui(self.guiDirectory .. "ccGui.xml", "CallContractorsGui", CCGui:new())
end

function CallContractors:onMissionInitialize(baseDirectory, missionCollaborators)
end

function CallContractors:onSetMissionInfo(missionInfo, missionDynamicInfo)
end

function CallContractors:onLoad()
end

function CallContractors:onPreLoadMap(mapFile)
end

function CallContractors:onCreateStartPoint(startPointNode)
end

function CallContractors:onLoadMap(mapNode, mapFile)
end

function CallContractors:onPostLoadMap(mapNode, mapFile)
end

function CallContractors:onLoadSavegame(savegameDirectory, savegameIndex)
    local savegameFilename = Utils.getFilename(self.savegameFilename, savegameDirectory)
    if fileExists(savegameFilename) then
        local xmlFile = loadXMLFile("CallContractorsXml", savegameFilename)
        self.contractsManager:onLoadSavegame(xmlFile, "callContractors")
        delete(xmlFile)
    end
end

function CallContractors:onPreLoadVehicles(xmlFile, resetVehicles)
end

function CallContractors:onPreLoadItems(xmlFile)
end

function CallContractors:onPreLoadOnCreateLoadedObjects(xmlFile)
end

function CallContractors:onLoadFinished()
end

function CallContractors:onStartMission()
end

function CallContractors:onMissionStarted()
end

function CallContractors:onWriteStream(streamId)
end

function CallContractors:onReadStream(streamId)
end

function CallContractors:onUpdate(dt)
    self.contractsManager:update(dt)
end

function CallContractors:onUpdateTick(dt)
end

function CallContractors:onWriteUpdateStream(streamId, connection, dirtyMask)
end

function CallContractors:onReadUpdateStream(streamId, timestamp, connection)
end

function CallContractors:onMouseEvent(posX, posY, isDown, isUp, button)
end

function CallContractors:onKeyEvent(unicode, sym, modifier, isDown)
end

function CallContractors:onDraw()
end

function CallContractors:onPreSaveSavegame(savegameDirectory, savegameIndex)
end

function CallContractors:onPostSaveSavegame(savegameDirectory, savegameIndex)
    local savegameFilename = Utils.getFilename(self.savegameFilename, savegameDirectory)
    local xmlFile = createXMLFile("CallContractorsXml", savegameFilename, "callContractors")
    self.contractsManager:onSaveSavegame(xmlFile, "callContractors")
    saveXMLFile(xmlFile)
    delete(xmlFile)
end

function CallContractors:onPreDeleteMap()
end

function CallContractors:onDeleteMap()
end

function CallContractors:onLoadHelpLine()
    --return self.directory .. "gui/helpLine.xml"
end

function CallContractors:openGui()
    if not self.gui.target:getIsOpen() then
        if g_currentMission:getFarmId() ~= 0 then
            if self.gui.target:onPreOpen(g_currentMission.player.farmId) > 0 then
                g_gui:showGui(self.gui.name)
            else
                g_currentMission:showBlinkingWarning(g_i18n:getText("warning_cc_noFarmlands"), 3000)
            end
        else
            g_currentMission:showBlinkingWarning(g_i18n:getText("warning_cc_noFarm"), 3000)
        end
    end
end
