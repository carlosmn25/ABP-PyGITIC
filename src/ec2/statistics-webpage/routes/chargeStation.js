const express = require('express')
const router = express.Router()
const aws = require('aws-sdk')

const credentials = new aws.SharedIniFileCredentials({profile: 'default'})
aws.config.credentials = credentials

const ddb = new aws.DynamoDB({region: 'us-east-1'})

router.get('/:id_e/:id_p', (req, res) => {

    //Obten ID de la URL
    var id_e = req.params.id_e
    var id_p = req.params.id_p

    //Obtener datos de dynamoDB
    var electrolineras_prom = ddb.getItem({
        TableName: 'Electrolinera',
        Key: {
            'ID_Electrolinera': {N: id_e}
        }
    }).promise()

    var puntoscarga_prom = ddb.getItem({
        TableName: 'PuntoCarga',
        Key: {
            'ID_PuntoCarga': {N: id_p}
        }
    }).promise()

    var estados_prom = ddb.scan({
        TableName: 'Estado',
        FilterExpression: 'ID_PuntoCarga = :id',
        ExpressionAttributeValues: {
            ':id': {N: id_p}
        }
    }).promise()

    Promise.all([electrolineras_prom, puntoscarga_prom, estados_prom]).then((values) => {
        res.render('chargeStation/pointofcharge', {
            electrolinera: values[0].Item,
            puntoscarga: values[1].Item,
            estados: values[2].Items
        })
    })
})

router.get('/:id', (req, res) => {

    //Obten ID de la URL
    var id = req.params.id

    //Obtener datos de dynamoDB
    var electrolineras_prom = ddb.getItem({
        TableName: 'Electrolinera',
        Key: {
            'ID_Electrolinera': {N: id}
        }
    }).promise()

    var puntoscarga_prom = ddb.scan({
        TableName: 'PuntoCarga',
        FilterExpression: 'ID_Electrolinera = :id',
        ExpressionAttributeValues: {
            ':id': {N: id}
        }
    }).promise()

    Promise.all([electrolineras_prom, puntoscarga_prom]).then((values) => {
        res.render('chargeStation/chargestation', {
            electrolinera: values[0].Item,
            puntoscarga: values[1].Items
        })
    })
})

router.get('/', (req, res) => {

    //Obtener datos de dynamoDB
    var electrolineras_prom = ddb.scan({
        TableName: 'Electrolinera'
    }).promise()

    var puntoscarga_prom = ddb.scan({
        TableName: 'PuntoCarga'
    }).promise()

    Promise.all([electrolineras_prom, puntoscarga_prom]).then((values) => {
        res.render('chargeStation/index', {
            electrolineras: values[0].Items,
            puntoscarga: values[1].Items
        })
    })
})

module.exports = router;