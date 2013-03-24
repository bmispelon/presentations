.. include:: <s5defs.txt>

GCBV: TL;DR
===========

.. sourcecode:: python

    from django.views import generic


Presentation
------------

* **Views**: :black:`definition, contrived examples.`
* **Generic views**: :black:`history and comparison.`
* **Common Patterns**: :black:`web application boilerplate.`
* **Class-based views**: :black:`django's generic view implementation.`
* **Mixins**: :black:`building blocks for reusable views.`
* **Tips**: :black:`making it harder to shoot yourself in the foot.`


What's a view?
--------------

The view contract (3 rules):
    * Callable
    * Takes a request (+captured URL parameters)
    * Return a response object


What's a "callable"?
--------------------

Basically, either an instance with a ``__call__`` method,

or a class.


Examples
--------

We're going to make a view that takes one parameter:

.. sourcecode:: python

    # urls.py

    url(r'^test/(?P<foo>\w+)/$', view=VIEW_CALLABLE)


A function
----------

.. sourcecode:: python

    def function_view(request, foo):
        return HttpResponse('OK: %s' % foo)


An anonymous function
---------------------

.. sourcecode:: python

    lambda request, foo: HttpResponse('OK: %s' % foo)


A method
--------

.. sourcecode:: python

    class ViewClass(object):
        def view(self, request, foo):
            return HttpResponse('OK: %s' % foo)

    method_view = ViewClass().view


A classmethod
-------------

.. sourcecode:: python

    class ViewClass(object):
        @classmethod
        def view(cls, request, foo):
            return HttpResponse('OK: %s' % foo)

    method_view = ViewClass.view


An callable instance
--------------------

.. sourcecode:: python

    class ViewClass(object):
        def __call__(self, request, foo):
            return HttpResponse('OK: %s' % foo)

    instance_view = ViewClass()


A class
-------

.. sourcecode:: python

    class ClassView(HttpResponse):
        def __init__(self, request, foo):
            super(ClassView, self).__init__('OK: %s' % foo)

    class_view = ClassView


A class
-------

.. sourcecode:: python

    class ClassView(object):
        def __new__(cls, request, foo):
            return HttpResponse('OK: %s' % foo)

    class_view = ClassView


Presentation
------------

Interlude


Generic views
-------------

Shipped with django since the beginning.

A set of readymade common views, with extension hooks.


Generic Views
-------------

Historically, django has been shipping **function**-based generic views (GFBV).

But they were limited, so it switched to **class**-based ones (GCBV) with 1.3.

The deprecation policy was followed, and with 1.5, GFBV are now gone.


History of generic views
------------------------

.. table:: :class: history

    =======  ==============   ===========
    Version  Function-based   Class-based
    =======  ==============   ===========
    1.0      ☀                ☁
    1.1      ☀                ☁
    1.2      ☀                ☁
    1.3      ☂                ☀
    1.4      ☂                ☀
    1.5      ☁                ☀
    =======  ==============   ===========

.. raw:: html

    <script type="text/javascript" src="20130327_django_cbv.js"></script>


An old function-based generic view
----------------------------------

.. sourcecode:: python

    def create_object(request, model=None, template_name=None,
            template_loader=loader, extra_context=None,
            post_save_redirect=None, login_required=False,
            context_processors=None, form_class=None):

        ...


Problems
--------

* Mixes captured URL parameters and extension hooks;
* Each extension hook requires a new argument to the function;
* Repeated logic between generic views;
* ...


Presentation
------------

Interlude


Anatomy of generic.View
-----------------------

It's a plain python object (no metaclass magic).

Derives directly from ``object``.

One method for each HTTP verb (GET, POST, ...), collected by a ``dispatch`` method.

A custom ``as_view`` constructor that can redefine class attributes.


Anatomy of generic.View
-----------------------

.. sourcecode:: python

    class View(object):
        def __init__(self, **initkwargs):
            for k, v in initkwargs.items():
                setattr(self, k, v) # self.foo = bar

        @classmethod
        def as_view(self, **initkwargs):
            cbv = cls(**initkwargs)
            return cbv.dispatch

        def dispatch(self, request, *args, **kwargs):
            handler = getattr(self, request.method)
            return handler(request, *args, **kwargs)


generic.View
------------

That's all. Not that complicated, right?

This object is the base of all generic views.

It's also a good base for your own views.


Usage example
-------------

.. sourcecode:: python

    class MyView(View):
        message = 'Hello world!'

        def get(self, request):
            return HttpResponse(self.message)

    view_en = MyView.as_view()
    view_hu = MyView.as_view(message='Császtok, gyíkok!')


The Bad
-------

More verbose than function-based counterpart.

Doesn't work too elegantly with view decorators (use mixins instead).

You can shoot yourself in the foot: complicated inheritance chains, metaclasses.


The Good
--------

Declarative style

Reusability through inheritance

Each method can have a single responsibility

Standard python objects (no magic)

HTTP method separation (good for APIs)


Presentation
------------

Interlude


Rendering a template
--------------------

.. sourcecode:: python

    from django.shortcuts import render

    def homepage(request):
        return render(request,
            'homepage.html'
        )


List some models
----------------

.. sourcecode:: python

    def article_list(request):
        queryset = Article.objects.all()
        return render(request,
            'blog/article_list.html',
            {'object_list': queryset}
        )


Display a particular model
--------------------------

.. sourcecode:: python

    def article_detail(request, pk):
        article = get_object_or_404(Article, pk=pk)
        return render(request,
            'blog/article_detail.html',
            {'object': article}
        )


Update a model
--------------

.. sourcecode:: python

    def article_update(request, pk):
        article = get_object_or_404(Article, pk=pk)
        if request.method == 'POST':
            form = ArticleForm(request.POST, instance=article)
            if form.is_valid():
                form.save()
                return HttpResponseRedirect('/articles/')
        else:
            form = ArticleForm(instance=article)
        return render(request,
            'blog/article_form.html',
            {'form': form, 'object': article}
        )


Delete a model
--------------

.. sourcecode:: python

    def article_delete(request, pk):
        article = get_object_or_404(Article, pk=pk)
        if request.method == 'POST':
            article.delete()
            return HttpResponseRedirect('/articles/')
        return render(request,
            'blog/article_delete.html',
            {'object': article}
        )


Rendering a template
--------------------

.. sourcecode:: python

    homepage = generic.TemplateView(
        template_name='homepage.html'
    )


List some models
----------------

.. sourcecode:: python

    article_list = generic.Listview(
        model=Article,
        template_name='blog/article_list.html',
    )


List some models
----------------

.. sourcecode:: python

    article_list = generic.Listview(
        model=Article,
    )


Display a particular model
--------------------------

.. sourcecode:: python

    article_detail = generic.DetailView(
        model=Article,
        template_name='blog/article_detail.hml',
    )


Display a particular model
--------------------------

.. sourcecode:: python

    article_detail = generic.DetailView(
        model=Article,
    )


Update a model
--------------

.. sourcecode:: python

    article_update = generic.UpdateView(
        model=Article,
        form_class=ArticleForm,
        success_url='/articles/',
        template_name='blog/article_form.html',
    )


Update a model
--------------

.. sourcecode:: python

    article_update = generic.UpdateView(
        model=Article,
        form_class=ArticleForm,
        success_url='/articles/',
    )


Delete a model
--------------

.. sourcecode:: python

    article_delete = generic.DeleteView(
        model=Article,
        success_url='/articles/',
        template_name='blog/article_delete.html',
    )


Delete a model
--------------

.. sourcecode:: python

    article_delete = generic.DeleteView(
        model=Article,
        success_url='/articles/',
    )


Presentation
------------

Interlude


The generic views
-----------------

* RedirectView
* TemplateView
* ListView
* DetailView
* FormView
* CreateView
* UpdateView
* DeleteView
* (and some date-related ones, not covered here)


Implementation
--------------

.. image:: cbv.png


Implementation
--------------

* Simple code but distributed in a lot of layers (RKK)
* Heavy use of mixins (multiple inheritance) to adhere to DRY
* Hard to document (but it's getting better)


In practice
-----------

Only a few attributes/methods are commonly changed:

* **Attributes**: ``template_name``, ``model``, ``form_class``,
                  ``pk_url_kwarg``, ``context_object_name``

* **Methods**: ``get_queryset``, ``get_form_kwargs``, ``get_form_initial``


Presentation
------------

Interlude


What is a mixin?
----------------

Just a normal python class.

Usually needs to be combined with a more "concrete" one to fully work.

Not instanciated on its own.


Why use them?
-------------

Share code (methods or attributes) between two views of different nature.

Isolate functionalities in one single unit of code (more maintainable).

A bit like a decorator for a functional view, but with more dimensions.


LoginRequiredMixin
------------------

.. sourcecode:: python

    class LoginRequiredMixin(object):
        def dispatch(self, request, *args, **kwargs):
            if request.user.is_anonymous():
                return redirect_to_login(request.get_full_path())
            return super(LoginRequiredMixin, self).dispatch(
                request, *args, **kwargs)
            )


Usage
-----

.. sourcecode:: python

    class ProtectedView(LoginRequiredMixin, generic.View):
        def get(self, request):
            username = request.user.username
            return HttpResponse('Hello %s' % username)


UserQuerysetMixin
-----------------

.. sourcecode:: python

    class UserQuerysetMixin(object):
        user_field = 'user'

        def get_queryset(self):
            queryset = super(UserQuerysetMixin, self).\
                get_queryset()
            fkwargs = {self.user_field: self.request.user}
            return queryset.filter(**kwargs)


Usage
-----

.. sourcecode:: python

    class Article(models.Model):
        author = models.ForeignKey('auth.User')
        title = models.CharField()
        body = models.TextField()

    class MyArticlesListView(LoginRequiredMixin,
                             UserQuerysetMixin, ListView):
        model = Article
        user_field = 'author'

    # Will only show articles for which the current logged-in
    # user is the author.


Usage (2)
---------

.. sourcecode:: python

    class ArticleForm(forms.ModelForm):
        class Meta:
            model = Article
            fields = ('title', 'body')

    class ArticleUpdateView(LoginRequiredMixin,
                            UserQuerysetMixin, UpdateView):
        model = Article
        form_class = ArticleForm
        user_field = 'author'

    # Will only let a user update the articles he/she authored.
    # Will raise a 404 otherwise.


SelectRelatedMixin
------------------

.. sourcecode:: python

    class SelectRelatedMixin(object):
        select_related = ()
        def get_queryset(self):
            queryset = super(SelectRelatedMixin, self).\
                get_queryset()
            return queryset.select_related(*self.select_related)


Usage
-----

.. sourcecode:: python

    class ArticleListView(SelectRelatedMixin, ListView):
        model = Article
        select_related = ('author',)

    # will perform Article.objects.select_related('author')


Combining
---------

.. sourcecode:: python

    class MyArticleListView(LoginRequiredMixin, UserQuerysetMixin,
                            SelectRelatedMixin, ListView):
        model = Article
        user_field = 'author'
        select_related = ('author',)

    # Article.objects.filter(author=user).select_related('author')


Presentation
------------

Interlude


Tips for not shooting yourself in the foot
------------------------------------------

Mixins always inherit from ``object``, or from another mixin.

Mixins always go "on the left" in the inheritance chain.

Always call ``super(...)`` when overriding a method.

When inheriting, only use one concrete view (and several mixins if needed)


Style tips
----------

.. sourcecode:: python

    # views.py
    class MyView(View):
        # some code here
    
    
    # urls.py
    from myapp.views import MyView

    url(r'^/foo/$', MyView.as_view(foo='bar')) # ugly


Style tips
----------

.. sourcecode:: python

    # views.py
    class MyView(View):
        # some code here
    
    my_view = MyView.as_view(foo='bar')
    
    
    # urls.py

    url(r'^/foo/$', 'myapp.my_view') # better, transparent


Style tips
----------

.. sourcecode:: python

    # views.py
    class MyView(View):
        # some code here
    
    my_view = MyView.as_view(foo='bar')
    
    
    # urls.py
    from myapp.views import my_view

    url(r'^/foo/$', my_view) # even better for debugging


Presentation
------------

Interlude
