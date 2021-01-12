/** Part of project demonstrated at ETHIndia 2.0 */
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

// TODO: Implement ownable contract
// TODO: Implement safemath

/// @title Attention economy for videos
/// @author Aniket Parate
/// @notice Version 0.0.1
/// @notice Contract for implementing basic functions for adding videos and tipping
/// @dev safemath and other security considerations are not implemented
contract Attention {
    uint initialViewFee = 1000000000000000000 wei;
    address payable owner = 0x62654dA0eF6695d8ca361199278eD0aE00023BDD;

    /// @notice structure for storing Video details in the blockchain
    /// @dev ipfs hash and creator details to be implemented later
    struct Video {
        string name;
        string description;         //Other COmplementary things like date n all can be implemented
        uint videoId;               //More advanced functionality like category can also be implemented
        //address payable creatorId;
        address payable[] users;
        //string ipfsHash;          //To be implemented Later
        //bool isPrivate;
    }

    /// @notice Public variable for storing total number of videos
    uint public videoNos;

    /// @notice Mapping from video id to the video struct stored on blockchain
    mapping (uint => Video) public videos;

    /// @notice Event indicating video addition
    /// @dev Including users and Videos array hence no need to declare a constructor
    event videoAdded(
        uint videoId,
        address payable creatorId
    );

    /// @dev Adds Video Details to the blockchain
    /// @param _name Name of Video
    /// @param _description Description of Video
    function addVideo(string memory _name, string memory _description) public {
        //require(bytes(_name).length != 0, "Name of the Video cannot be Empty");
        videoNos++;
        uint _videoId = videoNos;
        Video memory video = Video(
            _name,
            _description,
            _videoId,
            new address payable[](1)
        );
        video.users[0] = msg.sender;
        videos[_videoId] = video;
        emit videoAdded(_videoId, msg.sender);
    }

    /// @notice Distributes the tip given by a user to all the previous tippers and the creator
    /// @dev Current implementation model is just a proportional distribution model
    /// @param _videoId Id of the video
    function videoEarnings(uint _videoId) public payable {
        Video storage videoClicked = videos[_videoId];              // TODO: Check for Refactoring
        //require(msg.sender != videoClicked.creatorId);

        uint views;
        if(videoClicked.users.length == 1){
            owner.transfer(initialViewFee/80);      // 1.25% of value for the company
            videoClicked.users[0].transfer(79*(initialViewFee/80));
        }
        else{
            views = videoClicked.users.length - 1;
            owner.transfer(initialViewFee/80);      // 1.25% of value for the company
            videoClicked.users[0].transfer(9*initialViewFee/20);
            uint deno;
            if(views % 2 == 0)
                deno = (views/2)*(views + 1);
            else{
                deno = views*((views+1)/2);
                uint fraction = 0;
                uint num = 0;
                for(uint i = 1; i < videoClicked.users.length; i++){
                    num = views - (i-1);
                    fraction = num/deno;
                    videoClicked.users[i].transfer(fraction * (initialViewFee / 2));
                }
            }
        }
        

        if(msg.sender != videoClicked.users[0])                         // TODO: Implement check with all users
            videoClicked.users.push(msg.sender);                      //Check Whether the user is already in the users List
        
        //Persisting Video and User
        videos[_videoId] = videoClicked;
    }

    /// @notice gets views on video
    /// @param _videoId Id of the video
    function displayViews(uint _videoId) public view returns(uint) {
        return videos[_videoId].users.length - 1;
    }
}
