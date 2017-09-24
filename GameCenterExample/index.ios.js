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
  
// const { RNGameCenter  } = NativeModules;
import RNGameCenter from './RNGameCenter';
let leaderboardIdentifier="high_scores"
// let achievementIdentifier="pro_award"
let achievementIdentifier="novice_award"
// console.log(Object.getOwnPropertyNames(RNGameCenter).filter(function (p) {return typeof RNGameCenter[p] === 'function';}));
// const RNGameCenter=NativeModules.ReactNativeGameCenter



import Icon from 'react-native-vector-icons/MaterialCommunityIcons'
const {width, height} = Dimensions.get('window');




export default class GameCenterExample extends Component {
  constructor(props){
  	super(props);
  	this.state = {score:5};

    this.showAchievements=this.showAchievements.bind(this)
    this.showLeaderboard=this.showLeaderboard.bind(this)
    this.getAchievements=this.getAchievements.bind(this)
    this.getPlayer=this.getPlayer.bind(this)
    this.loadPlayers=this.loadPlayers.bind(this)
    this.reportAchievement=this.reportAchievement.bind(this)
    this.updateAchievements=this.updateAchievements.bind(this)
    this.getLeaderboardPlayers=this.getLeaderboardPlayers.bind(this)
    this.challengeWithScore=this.challengeWithScore.bind(this)
    this.submitLeaderboardScore=this.submitLeaderboardScore.bind(this)
    this.resetAchievements=this.resetAchievements.bind(this)
    this.incrementScore=this.incrementScore.bind(this)
    this.decrementScore=this.decrementScore.bind(this)
  }
componentDidMount() {

  try{
  RNGameCenter.init({leaderboardIdentifier}).then((o)=>{
    console.log("init: ",o)
  }).catch((e)=>{console.warn("e",e)})
  // RNGameCenter.initPlayer2()
  } catch (e) {console.log("ERRORRRR RNGameCenter.authenticateLocalPlayer",e);}


}
incrementScore(){
this.setState({score:this.state.score+1})
}
decrementScore(){
this.setState({score:this.state.score+1})
}
loadPlayers(){}
getPlayer(){
  try{
  RNGameCenter.getPlayer().then((o)=>{
    console.log("getPlayer:",o)
    return RNGameCenter.loadPlayers()
  }).then((o)=>{
    console.log("loadPlayers: ",o)
    }).catch((e)=>{
    console.warn("e",e)
  })
  } catch (e) {console.log("ERRORRRR RNGameCenter.getPlayer",e);}
}


showLeaderboard(){
  try{
  RNGameCenter.showLeaderboard({leaderboardIdentifier})
} catch (e) {console.log("ERRORRRR RNGameCenter.showLeaderboard",e);}
}
getLeaderboardPlayers(){
  try{


  RNGameCenter.getLeaderboardPlayers({playerIds:[]})
} catch (e) {console.log("ERRORRRR RNGameCenter.getLeaderboardPlayers",e);}
}
submitLeaderboardScore(){
  try{
  // RNGameCenter.submitLeaderboardScore({leaderboardIdentifier})
  RNGameCenter.submitLeaderboardScore({score:this.state.score,leaderboardIdentifier}).then((o)=>{
    // alert(o)
    this.showLeaderboard()
  }).catch((e)=>console.warn("e",e))
} catch (e) {console.log("ERRORRRR RNGameCenter.showLeaderboard",e);}

}



challengeWithScore(){
  try{

  // RNGameCenter.challengeWithScore().then((o)=>{
  // RNGameCenter.findScoresOfFriendsToChallenge({score:this.state.score,message:"my message",players:["G:8135064222"],achievementIdentifier:"novice_award"}).then((o)=>{
  // RNGameCenter.challengeWithScore({score:this.state.score,message:"my message",players:["G:8135064222"],achievementIdentifier:"novice_award"}).then((o)=>{
  RNGameCenter.challengeComposer({score:this.state.score,message:"my message",players:["G:8135064222"],achievementIdentifier:"novice_award"}).then((o)=>{
    alert(o)

  }).catch((e)=>console.warn("e",e))
} catch (e) {console.log("ERRORRRR RNGameCenter.showLeaderboard",e);}
}




showAchievements(){
  try{
  RNGameCenter.showAchievements({showsCompletionBanner:true,percentComplete:100,achievementIdentifier})
} catch (e) {console.log("ERRORRRR RNGameCenter.showAchievements",e);}
}
getAchievements(){
  try{
  RNGameCenter.getAchievements().then((o)=>{
    console.log("getAchievements",o)
  }).catch((e)=>{console.warn("getAchievements",e)})
} catch (e) {console.log("ERRORRRR RNGameCenter.getAchievements",e);}
}
updateAchievements(){
  try{
  RNGameCenter.updateAchievements()
  } catch (e) {console.log("ERRORRRR RNGameCenter.updateAchievements",e);}
}
reportAchievement(){
  try{
  RNGameCenter.reportAchievement({achievementIdentifier,percentComplete:100,showsCompletionBanner:true})
  } catch (e) {console.log("ERRORRRR RNGameCenter.reportAchievement",e);}
}
resetAchievements(){
  try{
  RNGameCenter.resetAchievements()
} catch (e) {console.log("ERRORRRR RNGameCenter.resetAchievements",e);}

}



  render() {
    const {score} =this.state
    return (
      <View style={s.container}>
        <Text style={s.headingText}>
React Native Game Center
        </Text>




<View style={[s.rowContainer,s.spaceAround,s.margin10,s.border]}>
            <TouchableOpacity onPress={this.decrementScore} style={[s.rowItem,s.centerItem]}>
                <Icon name={"minus"} size={25} color="rgba(0,0,0,0.5)"/>
            </TouchableOpacity>
            <View onPress={this.decrementScore} style={[s.rowItem,s.centerItem]}>
            <Text style={s.scoreText}>
              Score: {score}
            </Text>
          </View>
              <TouchableOpacity onPress={this.incrementScore} style={[s.rowItem,s.centerItem]}>
                  <Icon name={"plus"} size={25} color="rgba(0,0,0,0.5)"/>
              </TouchableOpacity>

          </View>
          <TouchableOpacity onPress={()=>{

// NativeModules.RNGameCenter.getPlayerFriends().then((o)=>{
NativeModules.RNGameCenter.challengeComposer(100,{}).then((o)=>{
  console.log("o",o)
})
.catch((e)=>{
  console.warn("e",e)
})
              }} style={[s.rowItem,s.centerItem]}>
            <Icon name={"circle"} size={25} color="rgba(0,0,0,0.5)"/>
          </TouchableOpacity>




          <View style={[s.rowTitleContainer,]}>
              <Text style={[s.titleText]}>player  </Text>
          </View>
          <View style={[s.rowContainer,]}>
            <TouchableOpacity onPress={this.challengeWithScore} style={[s.rowContainer,]}>
              <Icon name={"share-variant"} size={25} color="rgba(0,0,0,0.5)"/>
            </TouchableOpacity>
            <TouchableOpacity onPress={this.getPlayer} style={[s.rowContainer,]}>
                <Icon name={"information"} size={25} color="rgba(0,0,0,0.5)"/>
            </TouchableOpacity>
          </View>

          <View style={[s.rowTitleContainer,]}>
              <Text style={[s.titleText]}>Leaderboard  </Text>
          </View>
<View style={[s.rowContainer,]}>
          <TouchableOpacity onPress={this.showLeaderboard} style={[]}>
            <Icon name={"format-list-bulleted"} size={25} color="rgba(0,0,0,0.5)"/>
          </TouchableOpacity>
          <TouchableOpacity onPress={this.submitLeaderboardScore} style={[]}>
          <Icon name={"content-save"} size={25} color="rgba(0,0,0,0.5)"/>
          </TouchableOpacity>

          <TouchableOpacity onPress={this.getLeaderboardPlayers} style={[]}>
          <Icon name={"account-multiple"} size={25} color="rgba(0,0,0,0.5)"/>
          </TouchableOpacity>


</View>

<View style={[s.rowTitleContainer,]}>
    <Text style={[s.titleText]}>Achievements  </Text>
</View>
<View style={[s.rowContainer,]}>


  <TouchableOpacity onPress={this.showAchievements} style={[s.rowContainer,]}>
    <Icon name={"format-list-bulleted"} size={25} color="rgba(0,0,0,0.5)"/>
  </TouchableOpacity>
  <TouchableOpacity onPress={this.resetAchievements} style={[s.rowContainer,]}>
    <Icon name={"delete"} size={25} color="rgba(0,0,0,0.5)"/>
  </TouchableOpacity>

  <TouchableOpacity onPress={this.getAchievements} style={[s.rowContainer,]}>
    <Icon name={"information"} size={25} color="rgba(0,0,0,0.5)"/>
  </TouchableOpacity>
  <TouchableOpacity onPress={this.reportAchievement} style={[s.rowContainer,]}>
    <Icon name={"trophy"} size={25} color="rgba(0,0,0,0.5)"/>
  </TouchableOpacity>


  <TouchableOpacity onPress={this.updateAchievements} style={[s.rowContainer,]}>
    <Icon name={"content-save"} size={25} color="rgba(0,0,0,0.5)"/>
  </TouchableOpacity>

</View>











      </View>
    );
  }
}
let BUTTON_ROW_NUM_OF_BUTTONS=3
      let BUTTON_ROW_HEIGHT=50
      let BUTTON_HEIGHT=50
const s = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  headingText: {
    fontSize: 30,
    fontWeight: "900",
    textAlign: 'center',

  },
  scoreText: {
    fontSize: 20,
    fontWeight: "900",
    textAlign: 'center',

  },
  rowTitleContainer:{flexDirection: 'row',},
titleText:{fontWeight:"800"},
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  border: {borderWidth:1,borderColor:"red",borderRadius:5,},
  centerItem:{justifyContent:"center",alignItems:"center",},
  margin10:{margin:10,},
  rowContainer:{flexDirection: 'row',height:BUTTON_ROW_HEIGHT,},
  spaceAround:{justifyContent: 'space-around',alignItems: 'center',},
  spaceBetween:{justifyContent: 'space-between',alignItems: 'center',},
  rowItem:{backgroundColor: "transparent",width:width/BUTTON_ROW_NUM_OF_BUTTONS-20,height: BUTTON_HEIGHT, borderRadius:5,},
  rowItemBorder:{borderWidth:0.8,borderColor:"rgba(0,0,0,0.1)"},

  viewShadow:{shadowOpacity: 1,shadowOffset: {width: 0,height: 5},shadowRadius: 4,shadowColor:"rgba(0,0,0,0.6)",},

});

AppRegistry.registerComponent('GameCenterExample', () => GameCenterExample);
