/**
 * services list admin panel handlers
 *
 * @author Viacheslav Lotsmanov
 * @license GNU/AGPLv3
 * @see {@link https://www.gnu.org/licenses/agpl-3.0.txt|License}
 */

require! {
	\../../core/request-handler : {RequestHandler}
	\../../site/models/models : {ServicesList}
	
	\../utils : {go-auth, block-post, has-crap}
	
	\../ui-objects/menu : menu
	\../../site/traits : {page-trait}
}

const type = \serviceslist


export class AddServiceHandler extends RequestHandler
	mode = \add
	
	get: (req, res)!->
		return if go-auth req, res
		
		(err, html) <-! res.render \serviceslist-form, {
			type
			page-trait
			mode
		}
		return if has-crap res, err
		
		res.send html .end!
	
	post: (req, res)!->
		return if block-post req, res
		
		data = new ServicesList req.body
		
		(err, status) <-! data.save
		return if has-crap res, err, true
		
		res.json status: \success


export class UpdateServiceHandler extends RequestHandler
	mode = \edit
	
	get: (req, res)!->
		return if go-auth req, res
		
		service = ServicesList.find-by-id req.params.id
		
		(err, data) <-! service.exec
		err = new Error('No data') if not err? and not data?
		return if has-crap res, err
		
		(err, html) <-! res.render \serviceslist-form, {
			type
			page-trait
			mode
			data: {
				id: data._id.to-string!
				data.name
				data.link
			}
		}
		return if has-crap res, err
		
		res.send html .end!
	
	post: (req, res)!->
		return if block-post req, res
		
		received = req.body.updated
		
		data = ServicesList
			.find-by-id req.params.id
			.set-options overwrite: true
		
		(err) <-! data.update received
		return if has-crap res, err, true
		
		res.json status: \success


export class ListServicesHandler extends RequestHandler
	get: (req, res)!->
		return if go-auth req, res
		
		services-list = ServicesList.find!
		
		(err, services-list) <-! services-list.exec
		return if has-crap res, err
		
		(err, html) <-! res.render \data-list, {
			type
			data: [{
				id: x._id.to-string!
				name: x.name
				link: x.link
			} for x in services-list]
			page-trait
		}
		return if has-crap res, err
		
		res.send html .end!
