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

    /// @notice Mapping from video id to the video struct stored on blockchain
    mapping (uint => Video) public idToVideo;

    /// @notice This can also be an alternative structure in which the videos can be stored
    /// @notice See for Tradeoffs
    // Video[] public videos;

    /// @notice Event emitted after video is addVideo
    event videoAdded(
        uint videoId,
        address payable creator
    );

    /// @notice Event after the amount is tipped
    event tipped(
        uint videoId,
        address payable creator,
        address payable tipper
    );

    /// @dev Adds Video Details to the blockchain
    /// @dev Add the necessary require statements
    /// @param _name Name of Video
    /// @param _description Description of Video
    // function addVideo(string memory _name, string memory _description) public {
    //     totalVideos++;
    //     uint _videoId = totalVideos;
    //     videos.push(Video(
    //         _videoId,
    //         _name,
    //         _description,
    //         msg.sender
    //     ));
    //     emit videoAdded(_videoId, msg.sender);
    // }
    function addVideo(string memory _name, string memory _description) public {
        totalVideos++;
        uint _videoId = totalVideos;
        Video memory video = Video(
            _videoId,
            _name,
            _description,
            msg.sender
        );
        idToVideo[_videoId] = video;
        emit videoAdded(_videoId, msg.sender);

    }

    /// @notice Function for tipping the creator of the video
    /// @param _videoId Id of the video
    /// @dev CAUTION Currently it is taking the index of array, to be modified to take video Id
    function tip(uint _videoId) public payable{
        Video storage myVideo = idToVideo[_videoId];
        address payable creator = myVideo.creator;
        uint myVideoId = myVideo.videoId;

        require(
            msg.value > 0, 
            "The tip should be non-zero."
        );

        creator.transfer(msg.value);
        emit tipped(myVideoId, creator, msg.sender);
    }

}