import 'dart:math';

import 'package:testing/Enums/sortTag.dart';
import 'package:testing/Util/miscTools.dart';

///The class that gets the user's next recommended post
class HouseAlgorithm {
  late final Random _random;

  ///Initiates a House Algorithm from a random random
  HouseAlgorithm() {
    //Inits a random random
    _random = Random();
  }

  ///Initiates a House Algorithm using a set seed.
  HouseAlgorithm.fromSeed(int seed) {
    //Inits random from a seed
    _random = Random(seed);
  }
}

///This class contains the data for how much a user likes a certain tag
class TagLove {
  ///The tag that is getting data stored
  late final SortTag tag;

  ///An integer from [0-100) that describes how much a user likes/spends time on a post. Liking a post should automatically increase the love value.
  late int _love;

  ///An integer from [0-100) that describes when the last time a post of this tag was suggested. 0 being really recent. 99 being really rare.
  late int _rarity;

  ///Gets the current love value
  int getLove() {
    return _love;
  }

  ///Increases love but doesn't allow it to go above certain numbers
  void changeLove(int delta) {
    //Change the love
    _love += delta;
    //Bound love on interval [0,100)
    _love = MiscTools.boundInt(_love, 0, 100);
  }

  ///Gets the current rarity level
  int getRarity() {
    return _rarity;
  }

  ///Ticks up rarity by 1
  void tickRarity() {
    //Tick it up by 1
    _rarity++;
    //Bound it on interval [0,100)
    _rarity = MiscTools.boundInt(_rarity, 0, 100);
  }

  ///Resets the rarity back to 0
  void resetRarity() {
    _rarity = 0;
  }
}

///This class contains a userprofile for a defined location
class UserProfile {
  ///These are all of the tags that the user has seen.
  final List<TagLove> userTags;
  List<SortTag> unseenTags = [];

  ///Creates a user profile with the following tags
  UserProfile(this.userTags) {
    recalculateUnseenTags();
  }

  ///Calculates the tags that have not been seen by the user and stores them in the unseenTags list.
  void recalculateUnseenTags() {
    //set unseen tags to all values
    List<SortTag> presentTags = [];
    for(TagLove tag in userTags){
      presentTags.add(tag.tag);
    }
    unseenTags = MiscTools.getNotPresent(SortTag.values, presentTags);
  }
}
