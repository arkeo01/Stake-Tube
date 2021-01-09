// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

/// @title Attention economy for videos
/// @author Aniket Parate
/// @notice Contract implementing direct and complete payment to the artist as well as adding videos
contract StakeTube {

    /// @notice Structure for storing videos
    /// @dev currently ipfs is not implemented, implement using the string ipfsHash
    struct Video{
        uint videoId;
        string name;
        string description;
        address payable creator;
        // string ipfsHash;
    }

    /// @notice total number of videos stored currently.
    uint public totalVideos;

    /// @notice Array containing all the videos
    Video[] public videos;

    /// @notice mapping from id to Video object
    mapping(uint => Video) public idToVideo;

    /// @notice Event emitted after video is addVideo
    event videoAdded(
        uint videoId,
        address payable creator
    );

    /// @notice Event after the amount is tipped
    event tipped(
        uint videoId
    );

    /// @dev Adds Video Details to the blockchain
    /// @dev Add the necessary require statements
    /// @param _name Name of Video
    /// @param _description Description of Video
    function addVideo(string memory _name, string memory _description) public {
        totalVideos++;
        uint _videoId = totalVideos;
        videos.push(Video(
            _videoId,
            _name,
            _description,
            msg.sender
        ));
        emit videoAdded(_videoId, msg.sender);
    }

    /// @notice Function for tipping the creator of the video
    /// @dev CAUTION Currently it is taking the index of array, to be modified to take video Id
    function tip() public {
        Video storage myVideo = videos[0];
        uint myVideoId = myVideo.videoId;
        emit tipped(myVideoId);
    }

}