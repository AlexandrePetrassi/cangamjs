(function() {
    const initialize = () => {
        const c = document.getElementById("myCanvas");
        const ctx = c.getContext("2d");
        const world = new World()
        world.addSystem(DrawSystem, GravitySystem, MovableSystem)
        const first = world.createEntity()
        world.addComponent(
            first,
            TransformComponent,
            { position: { x: 10, y: 10 }, size: { x: 10, y: 10 } }
        )
        world.addComponent(
            first,
            DrawableComponent,
            { ctx: ctx }
        )
        world.addComponent(
            first,
            VelocityComponent,
            { velocity: { x: 0.25, y: 0 } }
        )
        const second = world.createEntity()
        world.addComponent(
            second,
            TransformComponent,
            { position: { x: 20, y: 20 }, size: { x: 10, y: 10 } }
        )
        world.addComponent(
            second,
            DrawableComponent,
            { ctx: ctx }
        )
        world.addComponent(
            second,
            VelocityComponent,
            { velocity: { x: 0, y: 0 } }
        )
        world.addComponent(
            second,
            GravityComponent
        )

        //const entities = []
        //entities.push(new Drawable(ctx, 10, 10, 10, 10))
        //entities.push(new Drawable(ctx, 25, 25, 10, 10))
        //entities.push(new Updateable(ctx, 25, 10, 10, 10))
        const frameRate = 1/60
        setInterval(() => {
            ctx.clearRect(0, 0, 800, 600)
            world.update()
            //Updateable.prototype.instances.update()
            //Drawable.prototype.instances.update()
        }, frameRate)
    }

    const urlAlphabet =
      'ModuleSymbhasOwnPr-0123456789ABCDEFGHNRVfgctiUvz_KqYTJkLxpZXIjQW'

    const getID = (size = 21) => {
      let id = ''
      let i = size
      while (i--) {
        id += urlAlphabet[(Math.random() * 64) | 0]
      }
      return id
    }

    const World = function() {
        const entities = {}
        const tags = {}
        const components = {}
        const stores = {}
        const systems = []

        this.getEntities = () => Object.keys(entities)

        this.createEntity = (tag) => {
            const id = getID()
            entities[id] = tag
            if(tag) tags[tag] = id
            return id
        }

        this.getId = (tag) => tags[tag]

        this.createComponent = (componentType, args = {}) => {
            const id = getID()
            components[id] = Object.assign(Object.create(componentType), args)
            return id
        }

        this.addSystem = (...args) => args.forEach(it => systems.push(it))

        this.getComponentStore = it => stores[it] || (stores[it] = {})

        this.getEntityStore = (entity, componentType) => {
            const componentStore = this.getComponentStore(componentType)
            return componentStore[entity] || (componentStore[entity] = [])
        }

        this.addComponent = (entity, componentType, args = {}) => {
            const component = this.createComponent(componentType, args)
            this.getEntityStore(entity, componentType).push(component)
        }

        this.has = (entity, componentType) => {
            return this.getEntityStore(entity, componentType).length > 0
        }

        this.getComponent = (entity, componentType) => {
            return components[this.getEntityStore(entity, componentType)[0]]
        }

        this.getComponents = (entity, componentType) => {
            return this.getEntityStore(entity, componentType)
                .map(it => components[it])
        }

        this.update = () => {
            systems.forEach(it => it(this))
        }
    }

    function TransformComponent() {
        this.position = { x: 0, y: 0 },
        this.size = { x: 0, y: 0 }
    }

    function VelocityComponent() { this.velocity = { x: 0, y: 0 } }

    function DrawableComponent() { this.ctx = undefined }

    function GravityComponent() { }

    const DrawSystem = (world) => {
        world.getEntities()
            .filter(it => {
                return world.has(it, DrawableComponent) &&
                    world.has(it, TransformComponent)
            })
            .forEach(it => {
                const draw = world.getComponent(it, DrawableComponent)
                const transform = world.getComponent(it, TransformComponent)
                draw.ctx.fillRect(
                    transform.position.x,
                    transform.position.y,
                    transform.size.x,
                    transform.size.y
                )
            })
    }

    const MovableSystem = (world) => {
        world.getEntities()
            .filter(it => {
                    return world.has(it, VelocityComponent) &&
                    world.has(it, TransformComponent)
            })
            .forEach(it => {
                const velocity = world.getComponent(it, VelocityComponent)
                const transform = world.getComponent(it, TransformComponent)
                transform.position.x += velocity.velocity.x
                transform.position.y += velocity.velocity.y
            })
    }

    const GravitySystem = (world) => {
        world.getEntities()
            .filter(it => {
                    return world.has(it, VelocityComponent) &&
                    world.has(it, GravityComponent)
            })
            .forEach(it => {
                const velocity = world.getComponent(it, VelocityComponent)
                velocity.velocity.x += Physics.gravityX
                velocity.velocity.y += Physics.gravityY
            })
    }

    const Physics = {
        gravityX: 0,
        gravityY: 0.025
    }

    initialize()
}())