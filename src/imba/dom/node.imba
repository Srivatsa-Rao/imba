var proxyHandler =
	def get target, name
		let ctx = target
		let val = undefined
		while ctx and val == undefined
			if ctx = ctx.#parent
				val = ctx[name]
		return val

extend class imba.dom.Node

	get #context
		##context ||= new Proxy(self,proxyHandler)

	get #parent
		##parent or this.parentNode

	def init$
		self

	# replace this with something else
	def replaceWith$ other
		if !(other isa Node) and other.replace$
			other.replace$(this)
		else
			self.parentNode.replaceChild(other,this)
		return other

	def insertInto$ parent
		parent.appendChild$(this)
		return this

	def insertBefore$ el, prev
		this.insertBefore(el,prev)

	def insertBeforeBegin$ other
		self.parentNode.insertBefore(other,this)

	def insertAfterEnd$ other
		if self.nextSibling
			self.nextSibling.insertBeforeBegin$(other)
		else
			self.parentNode.appendChild(other)
	
	def insertAfterBegin$ other
		if self.childNodes[0]
			self.childNodes[0].insertBeforeBegin$(other)
		else
			self.appendChild(other)