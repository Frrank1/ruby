# coding: utf-8
# frozen_string_literal: false

# Copyright Ayumu Nojima (野島 歩) and Martin J. Dürst (duerst@it.aoyama.ac.jp)

#--
# additions to class String for Unicode normalization
#++
class String

  # :call-seq:
  #    str.unicode_normalize(form=:nfc)
  #
  # Unicode Normalization---Returns a normalized form of +str+,
  # using Unicode normalizations NFC, NFD, NFKC, or NFKD.
  # The normalization form used is determined by +form+, which can
  # be any of the four values +:nfc+, +:nfd+, +:nfkc+, or +:nfkd+.
  # The default is +:nfc+.
  #
  # If the string is not in a Unicode Encoding, then an Exception is raised.
  # In this context, 'Unicode Encoding' means any of UTF-8, UTF-16BE/LE,
  # and UTF-32BE/LE, as well as GB18030, UCS_2BE, and UCS_4BE.
  # Anything other than UTF-8 is implemented by converting to UTF-8,
  # which makes it slower than UTF-8.
  #
  #   "a\u0300".unicode_normalize        #=> 'à' (same as "\u00E0")
  #   "a\u0300".unicode_normalize(:nfc)  #=> 'à' (same as "\u00E0")
  #   "\u00E0".unicode_normalize(:nfd)   #=> 'à' (same as "a\u0300")
  #   "\xE0".force_encoding('ISO-8859-1').unicode_normalize(:nfd)
  #                                      #=> Encoding::CompatibilityError raised
  #
  def unicode_normalize(form = :nfc)
    require 'unicode_normalize/normalize.rb' unless defined? UnicodeNormalize
    ## The following line can be uncommented to avoid repeated checking for
    ## UnicodeNormalize. However, tests didn't show any noticeable speedup
    ## when doing this. This comment also applies to the commented out lines
    ## in String#unicode_normalize! and String#unicode_normalized?.
    # String.send(:define_method, :unicode_normalize, ->(form = :nfc) { UnicodeNormalize.normalize(self, form) } )
    UnicodeNormalize.normalize(self, form)
  end

  # :call-seq:
  #    str.unicode_normalize!(form=:nfc)
  #
  # Destructive version of String#unicode_normalize, doing Unicode
  # normalization in place.
  #
  def unicode_normalize!(form = :nfc)
    require 'unicode_normalize/normalize.rb' unless defined? UnicodeNormalize
    # String.send(:define_method, :unicode_normalize!, ->(form = :nfc) { replace(unicode_normalize(form)) } )
    replace(unicode_normalize(form))
  end

  # :call-seq:
  #    str.unicode_normalized?(form=:nfc)
  #
  # Checks whether +str+ is in Unicode normalization form +form+,
  # which can be any of the four values +:nfc+, +:nfd+, +:nfkc+, or +:nfkd+.
  # The default is +:nfc+.
  #
  # If the string is not in a Unicode Encoding, then an Exception is raised.
  # For details, see String#unicode_normalize.
  #
  #   "a\u0300".unicode_normalized?        #=> false
  #   "a\u0300".unicode_normalized?(:nfd)  #=> true
  #   "\u00E0".unicode_normalized?         #=> true
  #   "\u00E0".unicode_normalized?(:nfd)   #=> false
  #   "\xE0".force_encoding('ISO-8859-1').unicode_normalized?
  #                                        #=> Encoding::CompatibilityError raised
  #
  def unicode_normalized?(form = :nfc)
    require 'unicode_normalize/normalize.rb' unless defined? UnicodeNormalize
    # String.send(:define_method, :unicode_normalized?, ->(form = :nfc) { UnicodeNormalize.normalized?(self, form) } )
    UnicodeNormalize.normalized?(self, form)
  end
end

