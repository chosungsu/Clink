import 'package:clickbyme/mongoDB/mongodb_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  static var res,
      collection_user,
      collection_share,
      collection_people,
      collection_memo,
      collection_homeview,
      collection_tag,
      collection_memoallalarm,
      collection_companynotice,
      collection_applicense,
      collection_noticebycompany,
      collection_noticebyusers,
      collection_howtouse,
      collection_linknet,
      collection_pinchannel,
      collection_pinchannelin;

  static connect() async {
    var db = await Db.create(MONGO_URL);
    await db.open().then((success) {
      Hive.box('user_info').put('server_status', db.isConnected);
    });
    collection_user = db.collection(USER_COLLECTION);
    collection_share = db.collection(SHARE_COLLECTION);
    collection_people = db.collection(PEOPLE_COLLECTION);
    collection_memo = db.collection(MEMO_COLLECTION);
    collection_homeview = db.collection(HOMEVIEW_COLLECTION);
    collection_tag = db.collection(TAG_COLLECTION);
    collection_memoallalarm = db.collection(MEMOALLALARM_COLLECTION);
    collection_companynotice = db.collection(COMPANYNOTICE_COLLECTION);
    collection_applicense = db.collection(APPLICENSE_COLLECTION);
    collection_noticebycompany = db.collection(APPNOTICEBYCOMPANY_COLLECTION);
    collection_noticebyusers = db.collection(APPNOTICEBYUSERS_COLLECTION);
    collection_howtouse = db.collection(HOWTOUSE_COLLECTION);
    collection_linknet = db.collection(LINKNET_COLLECTION);
    collection_pinchannel = db.collection(PINCHANNEL_COLLECTION);
    collection_pinchannelin = db.collection(PINUSERDATAIN_COLLECTION);
  }

  static Future getData({required String collectionname}) async {
    final arrdata;
    if (collectionname == 'user') {
      arrdata = await collection_user.find().toList();
      return arrdata;
    } else if (collectionname == 'sharehome') {
      arrdata = await collection_share.find().toList();
      return arrdata;
    } else if (collectionname == 'people') {
      arrdata = await collection_people.find().toList();
      return arrdata;
    } else if (collectionname == 'memo') {
      arrdata = await collection_memo.find().toList();
      return arrdata;
    } else if (collectionname == 'homeview') {
      arrdata = await collection_homeview.find().toList();
      return arrdata;
    } else if (collectionname == 'tag') {
      arrdata = await collection_tag.find().toList();
      return arrdata;
    } else if (collectionname == 'memoallalarm') {
      arrdata = await collection_memoallalarm.find().toList();
      return arrdata;
    } else if (collectionname == 'companynotice') {
      arrdata = await collection_companynotice.find().toList();
      return arrdata;
    } else if (collectionname == 'applicense') {
      arrdata = await collection_applicense.find().toList();
      return arrdata;
    } else if (collectionname == 'notibycompany') {
      arrdata = await collection_noticebycompany.find().toList();
      return arrdata;
    } else if (collectionname == 'notibyusers') {
      arrdata = await collection_noticebyusers.find().toList();
      return arrdata;
    } else if (collectionname == 'howtouse') {
      arrdata = await collection_howtouse.find().toList();
      return arrdata;
    } else if (collectionname == 'linknet') {
      arrdata = await collection_linknet.find().toList();
      return arrdata;
    } else if (collectionname == 'pinchannel') {
      arrdata = await collection_pinchannel.find().toList();
      return arrdata;
    } else if (collectionname == 'pinchannelin') {
      arrdata = await collection_pinchannelin.find().toList();
      return arrdata;
    } else {
      return [];
    }
  }

  static add(
      {required String collectionname,
      required Map<String, dynamic> addlist}) async {
    if (collectionname == 'user') {
      await collection_user.insertOne(addlist);
    } else if (collectionname == 'sharehome') {
      await collection_share.insertOne(addlist);
    } else if (collectionname == 'people') {
      await collection_people.insertOne(addlist);
    } else if (collectionname == 'memo') {
      await collection_memo.insertOne(addlist);
    } else if (collectionname == 'homeview') {
      await collection_homeview.insertOne(addlist);
    } else if (collectionname == 'tag') {
      await collection_tag.insertOne(addlist);
    } else if (collectionname == 'memoallalarm') {
      await collection_memoallalarm.insertOne(addlist);
    } else if (collectionname == 'companynotice') {
      await collection_companynotice.insertOne(addlist);
    } else if (collectionname == 'applicense') {
      await collection_applicense.insertOne(addlist);
    } else if (collectionname == 'notibycompany') {
      await collection_noticebycompany.insertOne(addlist);
    } else if (collectionname == 'notibyusers') {
      await collection_noticebyusers.insertOne(addlist);
    } else if (collectionname == 'linknet') {
      await collection_linknet.insertOne(addlist);
    } else if (collectionname == 'pinchannel') {
      await collection_pinchannel.insertOne(addlist);
    } else if (collectionname == 'pinchannelin') {
      await collection_pinchannelin.insertOne(addlist);
    }
  }

  static update(
      {required String collectionname,
      required String query,
      required String what,
      required Map<String, dynamic> updatelist}) async {
    if (collectionname == 'user') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_user.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'sharehome') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_share.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'people') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_people.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'memo') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_memo.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'homeview') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_homeview.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'tag') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_tag.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'memoallalarm') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_memoallalarm.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'companynotice') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_companynotice.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'applicense') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_applicense.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'notibycompany') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_noticebycompany.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'notibyusers') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_noticebyusers.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'linknet') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_linknet.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'pinchannel') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_pinchannel.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    } else if (collectionname == 'pinchannelin') {
      for (int i = 0; i < updatelist.length; i++) {
        await collection_pinchannelin.update(
            where.eq(query, what),
            modify.set(
                updatelist.keys.toList()[i], updatelist.values.toList()[i]));
      }
    }
  }

  static updatewwithtwoquery(
      {required String collectionname,
      required String query1,
      required String what1,
      required String query2,
      required String what2,
      required Map<String, dynamic> updatelist}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (collectionname == 'pinchannelin') {
      await MongoDB.getData(collectionname: collectionname);
      if (MongoDB.res != null) {
        for (int i = 0; i < updatelist.length; i++) {
          await collection_pinchannel.update(
              {query1: what1, query2: what2},
              modify.set(updatelist.keys.toList()[i],
                  [updatelist.values.toList()[i]]));
        }
      } else {
        await MongoDB.add(collectionname: collectionname, addlist: {
          query1: what1,
          query2: what2,
          updatelist.keys.toList()[0]: [updatelist.values.toList()[0]],
          updatelist.keys.toList()[1]: [updatelist.values.toList()[1]]
        });
      }
      await firestore.collection('Pinchannelin').get().then((value) {
        firestore.collection('Pinchannelin').add({
          query1: what1,
          query2: what2,
          updatelist.keys.toList()[0]: [updatelist.values.toList()[0]],
          updatelist.keys.toList()[1]: [updatelist.values.toList()[1]]
        });
      });
    }
  }

  static delete(
      {required String collectionname,
      required Map<String, dynamic> deletelist}) async {
    if (collectionname == 'user') {
      await collection_user.deleteOne(deletelist);
    } else if (collectionname == 'sharehome') {
      await collection_share.deleteOne(deletelist);
    } else if (collectionname == 'people') {
      await collection_people.deleteOne(deletelist);
    } else if (collectionname == 'memo') {
      await collection_memo.deleteOne(deletelist);
    } else if (collectionname == 'homeview') {
      await collection_homeview.deleteOne(deletelist);
    } else if (collectionname == 'tag') {
      await collection_tag.deleteOne(deletelist);
    } else if (collectionname == 'memoallalarm') {
      await collection_memoallalarm.deleteOne(deletelist);
    } else if (collectionname == 'companynotice') {
      await collection_companynotice.deleteOne(deletelist);
    } else if (collectionname == 'applicense') {
      await collection_applicense.deleteOne(deletelist);
    } else if (collectionname == 'notibycompany') {
      await collection_noticebycompany.deleteOne(deletelist);
    } else if (collectionname == 'notibyusers') {
      await collection_noticebyusers.deleteOne(deletelist);
    } else if (collectionname == 'linknet') {
      await collection_linknet.deleteOne(deletelist);
    } else if (collectionname == 'pinchannel') {
      await collection_pinchannel.deleteOne(deletelist);
    } else if (collectionname == 'pinchannelin') {
      await collection_pinchannel.deleteOne(deletelist);
    }
  }

  static find({
    required String collectionname,
    required String query,
    required String what,
  }) async {
    if (collectionname == 'user') {
      await collection_user.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'sharehome') {
      res = await collection_share.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'people') {
      res = await collection_people.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'memo') {
      res = await collection_memo.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'homeview') {
      res = await collection_homeview.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'tag') {
      res = await collection_tag.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'memoallalarm') {
      res = await collection_memoallalarm.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'companynotice') {
      res = await collection_companynotice.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'applicense') {
      res = await collection_applicense.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'notibycompany') {
      res = await collection_noticebycompany.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'howtouse') {
      res = await collection_howtouse.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'linknet') {
      res = await collection_linknet.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'pinchannel') {
      res = await collection_pinchannel.find({query: what}).forEach((v) {
        res = v;
      });
    } else if (collectionname == 'pinchannelin') {
      res = await collection_pinchannelin.find({query: what}).forEach((v) {
        res = v;
      });
    }
  }
}
