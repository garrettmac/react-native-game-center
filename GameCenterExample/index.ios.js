/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
    NativeModules,
    TouchableOpacity,Dimensions,
  Text,
  View
} from 'react-native';


import RNGameCenter from 'react-native-game-center';
const leaderboardIdentifier="high_scores"
// const achievementIdentifier="pro_award"
const achievementIdentifier="novice_award"

//
import Icon from 'react-native-vector-icons/MaterialCommunityIcons'
const {width, height} = Dimensions.get('window');




export default class GameCenterExample extends Component {
	constructor(props) {
		super(props);
		this.state = {
			score: 5
		};
		this.getPlayer = this.getPlayer.bind(this)
		this.getPlayerFriends = this.getPlayerFriends.bind(this)

		this.openLeaderboardModal = this.openLeaderboardModal.bind(this)
		this.submitLeaderboardScore = this.submitLeaderboardScore.bind(this)

		this.openAchievementModal = this.openAchievementModal.bind(this)
		this.getAchievements = this.getAchievements.bind(this)
		this.resetAchievements = this.resetAchievements.bind(this)
		this.submitAchievementScore = this.submitAchievementScore.bind(this)

		this.incrementScore = this.incrementScore.bind(this)
		this.decrementScore = this.decrementScore.bind(this)
	}
	componentDidMount() {

		//sets default leaderboardIdentifier
		RNGameCenter.init({leaderboardIdentifier})
		.then(console.log)
		.catch(console.warn)

		RNGameCenter.submitAchievementScore({percentComplete:50,achievementIdentifier:"novice_award"})
		//RNGameCenter.submitAchievementScore({percentComplete:"10",achievementIdentifier:"pro_award",hideCompletionBanner:true})

	}
	incrementScore() {
		this.setState({
			score: this.state.score + 1
		})
	}
	decrementScore() {
		this.setState({
			score: this.state.score + 1
		})
	}


	getPlayer() {
		RNGameCenter.getPlayer()
			.then(console.log)
			.catch(console.warn)

}
	getPlayerFriends() {
		RNGameCenter.getPlayerFriends()
			.then(console.log)
			.catch(console.warn)

}

// NOT SET UP
getPlayerImage() {
RNGameCenter.getPlayerImage()
	.then(console.log)
	.catch(console.warn)

}

openLeaderboardModal() {
	RNGameCenter.openLeaderboardModal({
			leaderboardIdentifier
		})
		.then(console.log)
		.catch(console.warn)
}

submitLeaderboardScore(score =30) {
	RNGameCenter.submitLeaderboardScore({
			score,
			leaderboardIdentifier
		})
		.then(console.log)
		.catch(console.warn)
}




openAchievementModal() {

	let options = {
		showsCompletionBanner: true,
		percentComplete: 100,
		achievementIdentifier
	};

	RNGameCenter.openAchievementModal(options)
		.then(console.log)
		.catch(console.warn)
}


getAchievements() {
	RNGameCenter.getAchievements()
		.then(JSON.stringify(console.log))
		.catch(console.warn)

}

submitAchievementScore(percentComplete=100,showsCompletionBanner=true) {
	  // NativeModules.RNGameCenter.reportAchievement({

	RNGameCenter.submitAchievementScore({
	// percentComplete,
	percentComplete:100,
		achievementIdentifier,
		// hideCompletionBanner:true,
	})
		.then(console.log)
		.catch(console.warn)
}


resetAchievements() {
	RNGameCenter.resetAchievements()
		.then(console.log)
		.catch(console.warn)
}



render() {
	const {
		score
	} = this.state
	RNGameCenter.getPlayerFriends().then((o)=>{
	  console.log("getPlayerFriends",o)
	})
	RNGameCenter.getPlayerImage().then((o)=>{
	  console.log("getPlayerImage",o)
	})
	return(
		<View style={s.container}>
				<View style={[{flex:1},s.center]}>
					<Text style={[s.margin10,s.headingText]}>React Native Game Center</Text>



						{/* Heading Title */}
						<View style={[s.headerComponentTitleContainer]}>
									<Text style={[s.headerComponentTitleTextStyle]}>Leaderboard</Text>
									<Text style={[s.headerComponentSubheading]}>Leaderboard Buttons</Text>
									<View style={[s.lineDivider]}/>
						</View>

<View style={[s.columnContainer]}>
	<TouchableOpacity onPress={this.decrementScore} style={[s.columnItem,s.center,s.button,s.centerItem,{backgroundColor:"#a94920",}]}>
	<Icon name={"minus"} size={25} color="rgba(0,0,0,0.5)"/>
</TouchableOpacity>

            <Text style={s.scoreText}>
              Score: {score}
            </Text>

						<TouchableOpacity onPress={this.incrementScore} style={[s.columnItem,s.center,s.button,s.centerItem,{backgroundColor:"#0ba8a0",}]}>
							<Icon name={"plus"} size={25} color="rgba(0,0,0,0.5)"/>
						</TouchableOpacity>

          </View>



				</View>



<View style={[{flex:2}]}>




	<View style={[s.columnContainer,{marginTop:40}]}>
	<TouchableOpacity onPress={this.openLeaderboardModal} style={[s.columnItem,s.center,s.button,{backgroundColor:"#32db64"}]}>
	<Text numberOfLines={2} style={[s.textStyle]}>open Leaderboard Modal</Text>
	</TouchableOpacity>
	<TouchableOpacity onPress={()=>this.submitLeaderboardScore(this.state.score)} style={[s.columnItem,s.center,s.button,{backgroundColor:"#32db64"}]}>
	<Text numberOfLines={2} style={[s.textStyle]}>submit Leaderboard Score</Text>
	</TouchableOpacity>

</View>




					{/* Heading Title */}
					<View style={[s.headerComponentTitleContainer]}>
								<Text style={[s.headerComponentTitleTextStyle]}>Player</Text>
								<Text style={[s.headerComponentSubheading]}>Player Buttons</Text>
								<View style={[s.lineDivider]}/>
					</View>


					<View style={[s.columnContainer]}>
            <TouchableOpacity onPress={this.getPlayer} style={[s.columnItem,s.center,s.button]}>
					<Text numberOfLines={2} style={[s.textStyle]}>get player</Text>
            </TouchableOpacity>

            <TouchableOpacity onPress={this.getPlayerFriends} style={[s.columnItem,s.center,s.button]}>
					<Text numberOfLines={2} style={[s.textStyle]}>get Player Friends</Text>
            </TouchableOpacity>
				 </View>








{/* Heading Title */}
<View style={[s.headerComponentTitleContainer]}>
			<Text style={[s.headerComponentTitleTextStyle]}>Achievements</Text>
			<Text style={[s.headerComponentSubheading]}>Achievements Buttons</Text>
			<View style={[s.lineDivider]}/>
</View>





		<View style={[s.columnContainer]}>
  <TouchableOpacity onPress={this.openAchievementModal} style={[s.columnItem,s.center,s.button,{backgroundColor:"#ba8a00",}]}>
					<Text numberOfLines={2} style={[s.textStyle]}>open AchievementModal</Text>
  </TouchableOpacity>

	<TouchableOpacity onPress={this.getAchievements} style={[s.columnItem,s.center,s.button,{backgroundColor:"#ba8a00",}]}>
					<Text numberOfLines={2} style={[s.textStyle]}>get Achievements</Text>
  </TouchableOpacity>

</View>


<View style={[s.columnContainer]}>


  <TouchableOpacity onPress={this.submitAchievementScore} style={[s.columnItem,s.center,s.button,{backgroundColor:"#ba8a00",}]}>
					<Text numberOfLines={2} style={[s.textStyle]}>submit Achievement Score</Text>
  </TouchableOpacity>

	<TouchableOpacity onPress={this.resetAchievements} style={[s.columnItem,s.center,s.button,{backgroundColor:"#ba8a00",}]}>
					<Text numberOfLines={2} style={[s.textStyle]}>reset Achievements</Text>
  </TouchableOpacity>
</View>




</View>


      </View>
	);
}
}





// RNGameCenter.init({leaderboardIdentifier})
AppRegistry.registerComponent('GameCenterExample', () => GameCenterExample);








let BUTTON_ROW_NUM_OF_BUTTONS = 3
let BUTTON_ROW_HEIGHT = 50
let BUTTON_HEIGHT = 50
const s = StyleSheet.create({
	container: {
		flex: 1,
		// justifyContent: 'center',
		// alignItems: 'center',
		backgroundColor: '#F5FCFF',
	},
	headingText: {
		fontSize: 25,
		marginBottom:40,
		fontWeight: "900",
		textAlign: 'center',

	},
	scoreText: {
		fontSize: 20,
		fontWeight: "900",
		textAlign: 'center',

	},
	rowTitleContainer: {
		flexDirection: 'row',
	},
	titleText: {
		fontWeight: "800"
	},
	instructions: {
		textAlign: 'center',
		color: '#333333',
		marginBottom: 5,
	},
	button: {
		borderWidth: 1,
		margin: 5,
		// padding: 15,
		paddingLeft: 5,
		paddingRight: 5,
		borderColor: "white",
		backgroundColor:"#488aff",
		borderRadius: 5,
	},
	centerItem: {
		borderRadius:25,
		borderWidth:4,
		borderColor:"rgba(0,0,0,0.2)",
		justifyContent: "center",
		alignItems: "center",
		borderRadius:25,
		height:50,
		width:50,
		backgroundColor:"red",
	},
	margin10: {
		margin: 10,
	},
	rowContainer: {
		flexDirection: 'row',
		height: BUTTON_ROW_HEIGHT,
	},
	spaceAround: {
		justifyContent: 'space-around',
		alignItems: 'center',
	},

	center:{justifyContent:"center",alignItems:"center",},
	spaceBetween: {
		justifyContent: 'space-between',
		alignItems: 'center',
	},
	rowItem: {
		backgroundColor: "transparent",
		width: width / BUTTON_ROW_NUM_OF_BUTTONS - 20,
		height: BUTTON_HEIGHT,
		borderRadius: 5,
	},
	rowItemBorder: {
		borderWidth: 0.8,
		borderColor: "rgba(0,0,0,0.1)"
	},
	textStyle:{color:"rgba(255,255,255,1)", textAlignVertical: "center", fontWeight:"700",textAlign: "center"},

	viewShadow: {
		shadowOpacity: 1,
		shadowOffset: {
			width: 0,
			height: 5
		},
		shadowRadius: 4,
		shadowColor: "rgba(0,0,0,0.6)",
	},

	headerComponentTouchableIcon:{margin: 5,},
	headerComponentSubheading:{fontSize: 17,color: '#444',margin: 5,fontWeight: '400'},
	headerComponentTitleContainer:{},
	headerComponentTitleTextStyle:{fontSize: 35,color: '#444',margin: 5,fontWeight: '700'},
	lineDivider:{width: 50,borderBottomWidth: 1,borderColor: '#e3e3e3',margin: 5},
	columnContainer:{flex: 1,flexDirection: 'row',
	justifyContent: 'center',
	justifyContent: 'space-between',
	justifyContent: 'space-around',
maxHeight:50,
	alignItems: 'center',},
	columnItem:{width:width/2-20, height: 50},

});

/*
//TODO coming soon
getLeaderboardPlayers(){

  let options = {playerIds:[]};

  _GameCenter.getLeaderboardPlayers(options)
}



invite(){
  let options = {playerIds:[]};
  _GameCenter.invite(options)
}

challengeComposer(){

  let options = {score:this.state.score,
    message:"my message",
    players:["G:8135064222"],
    achievementIdentifier:"novice_award"
  };

  _GameCenter.challengeComposer(options)
    .then(console.log)
  .catch(console.warn)
}



findScoresOfFriendsToChallenge(){
  _GameCenter.findScoresOfFriendsToChallenge()
    .then(console.log)
  .catch(console.warn)
}

loadLeaderboardPlayers(){
  _GameCenter.loadLeaderboardPlayers()
    .then(console.log)
  .catch(console.warn)
}



*/
