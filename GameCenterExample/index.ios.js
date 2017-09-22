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
const RNGameCenter=NativeModules.RNGameCenter
// const RNGameCenter=NativeModules.ReactNativeGameCenter

try{
RNGameCenter.init(leaderboardIdentifier).then((o)=>{
  console.log("init: ",o)
}).catch((e)=>{console.warn("e",e)})
// RNGameCenter.initPlayer2()
} catch (e) {console.log("ERRORRRR RNGameCenter.authenticateLocalPlayer",e);}


import Icon from 'react-native-vector-icons/MaterialCommunityIcons'
const {width, height} = Dimensions.get('window');

let leaderboardIdentifier="high_scores"


export default class GameCenterExample extends Component {
  constructor(props){
  	super(props);
  	this.state = {score:0};
    this.reportScore=this.reportScore.bind(this)
    this.showAchievements=this.showAchievements.bind(this)
    this.showLeaderboard=this.showLeaderboard.bind(this)
    this.getAchievements=this.getAchievements.bind(this)
    this.updateAchievements=this.updateAchievements.bind(this)
    this.submitScore=this.submitScore.bind(this)
    this.resetAchievements=this.resetAchievements.bind(this)
    this.incrementScore=this.incrementScore.bind(this)
    this.decrementScore=this.decrementScore.bind(this)
  }
componentDidMount() {

  try{
  RNGameCenter.init(leaderboardIdentifier).then((o)=>{
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
updateAchievements(){
  try{
  RNGameCenter.updateAchievements()
} catch (e) {console.log("ERRORRRR RNGameCenter.updateAchievements",e);}

}
resetAchievements(){
  try{
  RNGameCenter.resetAchievements()
} catch (e) {console.log("ERRORRRR RNGameCenter.resetAchievements",e);}

}
showLeaderboard(){
  try{
  // RNGameCenter.showLeaderboard({leaderboardIdentifier})
  RNGameCenter.showLeaderboard(leaderboardIdentifier)
} catch (e) {console.log("ERRORRRR RNGameCenter.showLeaderboard",e);}

}
submitScore(){
  try{
  // RNGameCenter.submitScore({leaderboardIdentifier})
  RNGameCenter.submitScore({score:this.state.score,leaderboardIdentifier:"highest_earnings"}).then((o)=>{
    console.log("o",o)
  })
  .catch((e)=>{
    console.warn("e",e)
  })
} catch (e) {console.log("ERRORRRR RNGameCenter.showLeaderboard",e);}

}

showAchievements(){
  try{

  RNGameCenter.showAchievements(leaderboardIdentifier)
} catch (e) {console.log("ERRORRRR RNGameCenter.showAchievements",e);}
}
getAchievements(){
  try{

  RNGameCenter.getAchievements().then((o)=>{
    console.log("getAchievements",o)
  })
  .catch((e)=>{
    console.warn("getAchievements",e)
  })
} catch (e) {console.log("ERRORRRR RNGameCenter.getAchievements",e);}
}
reportScore(score=this.state.score){
  try{
    RNGameCenter.reportScore({score,leaderboardIdentifier})
} catch (e) {console.log("ERRORRRR RNGameCenter.reportScore",e);}


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


          <TouchableOpacity onPress={this.updateAchievements} style={[s.rowContainer,]}>
            <Icon name={"content-save"} size={25} color="rgba(0,0,0,0.5)"/>
            <Text style={[]}>update Achievements </Text>
          </TouchableOpacity>



          <TouchableOpacity onPress={this.resetAchievements} style={[s.rowContainer,]}>
            <Icon name={"delete"} size={25} color="rgba(0,0,0,0.5)"/>
            <Text style={[]}>reset Achievements </Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={this.showLeaderboard} style={[s.rowContainer,]}>
            <Icon name={"format-list-bulleted"} size={25} color="rgba(0,0,0,0.5)"/>
            <Text style={[]}>show Leaderboard </Text>
          </TouchableOpacity>


          <TouchableOpacity onPress={this.reportScore} style={[s.rowContainer,]}>
            <Icon name={"file-chart"} size={25} color="rgba(0,0,0,0.5)"/>
            <Text style={[]}>report Score </Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={this.getAchievements} style={[s.rowContainer,]}>
            <Icon name={"trophy"} size={25} color="rgba(0,0,0,0.5)"/>
            <Text style={[]}>get Achievements </Text>
          </TouchableOpacity>
          <TouchableOpacity onPress={this.submitScore} style={[s.rowContainer,]}>
            <Icon name={"circle"} size={25} color="rgba(0,0,0,0.5)"/>
            <Text style={[]}>submitScore </Text>
          </TouchableOpacity>






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
