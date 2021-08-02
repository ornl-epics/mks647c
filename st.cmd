#!../../bin/linux-x86_64/mks647c

## You may have to change mks647c to something else
## everywhere it appears in this file

< envPaths

cd ${TOP}

## Register all support components
dbLoadDatabase "dbd/mks647c.dbd"
mks647c_registerRecordDeviceDriver pdbbase


#asynSetAutoConnectTimeout(1.0)
drvAsynIPPortConfigure( "mks647c1", "10.112.22.132:4001 tcp", 0, 0, 0 )

#enables debugging 0xff is the max setting
#asynSetTraceIOMask("mks647c1", 0,0xff)
#asynSetTraceMask("mks647c1", 0,0xff)




## Load record instances
dbLoadRecords("db/mks647c.db")
#################################################
# autosave

epicsEnvSet IOCNAME bl11a-SE-mks647c
epicsEnvSet SAVE_DIR /home/controls/var/$(IOCNAME)

save_restoreSet_Debug(0)

### status-PV prefix, so save_restore can find its status PV's.
save_restoreSet_status_prefix("BL11A:SE:mks647c:")

set_requestfile_path("$(SAVE_DIR)")
set_savefile_path("$(SAVE_DIR)")

save_restoreSet_NumSeqFiles(1)
save_restoreSet_SeqPeriodInSeconds(600)
set_pass1_restoreFile("$(IOCNAME).sav")

#################################################



cd ${TOP}/iocBoot/${IOC}
iocInit
#set mks haz to proper range 6 is 100 8 is 500

dbpf BL11A:SE:mks647c:AGasRange.VAL 6
dbpf BL11A:SE:mks647c:BGasRange.VAL 8
dbpf BL11A:SE:mks647c:CGasRange.VAL 6
dbpf BL11A:SE:mks647c:DGasRange.VAL 8



# Create request file and start periodic 'save'
epicsThreadSleep(5)
makeAutosaveFileFromDbInfo("$(SAVE_DIR)/$(IOCNAME).req", "autosaveFields")
create_monitor_set("$(IOCNAME).req", 5)

