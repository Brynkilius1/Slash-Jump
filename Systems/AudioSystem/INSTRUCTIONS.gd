#How to use:



#Setup:
#Add an AudioMaster node to the thing you want to make sounds
#Add as many AudioCollections as you want to the master
#You can even add AudioCollections to AudioCollections, fx you can have an 
#AudioCollection called "footsteps" and inside it you can have "footstepsgrass" and "footstepsstone"
#Add AudioStreamPlayers to the AudioCollections to have them play those sounds


#Usage:
#To play a random sound take the path of the audio master and perform the
#function "PlayRandomSound" and put in the name of the AudioCollection you're looking for, it has to match
#the name in the editor EXACTLY except without the "AudioCollection" part
#fx if you want to play an AudioCollection called "AudioCollectionSwingSword",
#write AudioMasterPath.PlayRandomSound("SwingSword")

#To stop a specific sound do the same thing but replace the function with "StopCollectionSound"

#Stopping all sounds will be added later
