/**
 * Created by Francois on 20/12/2015.
 */
var express = require('express');
var MongoClient = require('mongodb').MongoClient;
var config = require('../config')
var url = config.url_api;
var router = express.Router();

/* Add a comment */
router.get('/add/:idcinema/:roomname/:comment/:user/:star', function (req, res, next) {
    var id = req.params.idcinema;
    var name = req.params.roomname;
    var comment = req.params.comment;
    var user = req.params.user;
    var star = req.params.star;

    if (id == null || name == null || comment == null || user == null || star == null) {
        res.send({"error": "arguments"});
        return;
    }

    MongoClient.connect(url, function (err, db) {
        var toInsert = {'idcinema': id, 'roomname': name, 'comment': comment, 'user': user, 'start': start};
        db.collection('comment').insert(toInsert);
        db.close();
        res.send({"error": "ok", "inserted": toInsert});
    });
});

/* Get all comments  */
router.get('/list', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        db.collection('comment').find().toArray(function (err, doc) {
            db.close();
            res.send(doc);
        });
    })
});

/* Get comments of cinema and rooms */
router.get('/list/:idcinema/:roomname', function (req, res, next) {
    var id = req.params.idcinema;
    var room = req.params.roomname;

    if (id == null || roomname) {
        res.send({"error": "arguments"});
        return;
    }

    MongoClient.connect(url, function (err, db) {
        db.collection('comment').find({"idcinema": id, "roomname": room}).toArray(function (err, doc) {
            db.close();
            res.send(doc);
        });
    })
});

/* Drop comments */
router.get('/drop', function (req, res, next) {
    MongoClient.connect(url, function (err, db) {
        db.collection('comment').drop();
        db.close();
        res.send({"error": "ok"});
    });
});

module.exports = router;