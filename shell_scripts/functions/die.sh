die () 
{
  (($#)) && printf >&2 '%s\n' "$@"
  exit 1
}
