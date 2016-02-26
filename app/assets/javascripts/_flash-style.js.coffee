Growlyflash.DISMISS = """<a type="close" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></a>"""

Growlyflash.defaults = $.extend on, Growlyflash.defaults,
  align:   'right'  # horizontal aligning (left, right or center)
  delay:   4000     # auto-dismiss timeout (0 to disable auto-dismiss)
  dismiss: yes      # allow to show close button
  spacing: 10       # spacing between alerts
  target:  'body'   # selector to target element where to place alerts
  title:   no       # switch for adding a title
  type:    null     # bootstrap alert class by default
  class:   ['alert', 'growlyflash', 'fade']
