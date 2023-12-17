module cost_queue_mod
	implicit none
	
	type node
	  integer	:: x, y, d, n, cost
	end type
	
	type queue
	  type(node), allocatable :: buf(:)
	  integer                 :: n = 0
	contains
	  procedure :: top
	  procedure :: enqueue
	  procedure :: siftdown
	end type
	
	contains
	
	subroutine siftdown(this, a)
	  class (queue)           :: this
	  integer                 :: a, parent, child
	  associate (x => this%buf)
	  parent = a
	  do while(parent*2 <= this%n)
		child = parent*2
		if (child + 1 <= this%n) then 
		  if (x(child+1)%cost < x(child)%cost ) then
			child = child +1 
		  end if
		end if
		if (x(parent)%cost > x(child)%cost) then
		  x([child, parent]) = x([parent, child])
		  parent = child
		else
		  exit
		end if  
	  end do      
	  end associate
	end subroutine
	
	function top(this) result (res)
	  class(queue) :: this
	  type(node)   :: res
	  res = this%buf(1)
	  this%buf(1) = this%buf(this%n)
	  this%n = this%n - 1
	  call this%siftdown(1)
	end function
	
	subroutine enqueue(this, x, y, d, n, cost)
	  class(queue), intent(inout) 	:: this
	  integer                     	:: cost
	  integer            			:: x, y, d, n
	  type(node)                  	:: val
	  type(node), allocatable     	:: tmp(:)
	  integer                     	:: i
	  val%cost = cost
	  val%x = x
	  val%y = y
	  val%d = d
	  val%n = n

	  this%n = this%n +1  
	  if (.not.allocated(this%buf)) allocate(this%buf(1))
	  if (size(this%buf)<this%n) then
		allocate(tmp(2*size(this%buf)))
		tmp(1:this%n-1) = this%buf
		call move_alloc(tmp, this%buf)
	  end if
	  this%buf(this%n) = val
	  i = this%n
	  do 
		i = i / 2
		if (i==0) exit
		call this%siftdown(i)
	  end do
	end subroutine
	end module 


module procedures
	implicit none
	
contains

	function geth(direction) 
		integer, intent(in) :: direction
		integer :: geth

		geth = (1 - (2 * (direction / 2))) * mod(direction, 2)
	end function geth

	function getv(direction) 
		integer, intent(in) :: direction
		integer :: getv

		getv = (2 * (direction / 2) - 1) * mod(direction + 1, 2)
	end function getv
end module procedures

program clumsy_crucible
	use procedures
	use cost_queue_mod

	implicit none
	character(200) :: line
	character(32) :: filename
	integer strlen
	integer rows, cols
	integer, dimension(:,:), allocatable :: grid
	integer, dimension(:,:,:,:), allocatable :: visited
	integer x, y, d, n, cost, i, j, dist, io
	integer tempx, tempy, tempd, tempn, tempc
	logical does_not_go_back, is_in
	type(queue) :: positions
	type(node) :: val
	
	if (command_argument_count() > 0) then
		call get_command_argument(1, filename)
	else
		filename = 'input.txt'
	end if 

	open(unit=42, file=filename, status='old', action='read')
	! count columns 
	read(42, '(a)') line ! read all ( '(a)' ) characters in first line
	rewind(42) ! go back to the beginning of the document 
	strlen = len(line)

	cols = 0
	do i = 0, strlen
		if ( line(i:i) < '9' .AND. line(i:i) > '0' ) then
			cols = cols + 1
		end if
	end do

	rows = 0
	do
		read(42, *, iostat=io)
		if (io/=0) then
			exit
		end if
		rows = rows + 1
	end do

	rewind(42)

	!print*, 'Number of columns:', cols
	!print*, 'Number of rows:', rows

	allocate(grid(rows, cols))
	allocate(visited(rows, cols, 4, 10))

	do i = 1, rows, 1
		read(42, *) line
		do j = 1, cols, 1
			grid(i,j) = ichar(line(j:j)) - ichar('0')
			visited(i,j,:,:) = -1
		end do
		!write(*,*) grid(i,:)
	end do

	call positions%enqueue(1, 1, 0, 1, 0) 

	do while(positions%n > 0)
		val = positions%top()
		x = val%x
		y = val%y
		d = val%d
		n = val%n
		cost = val%cost

		if (visited(x, y, d + 1, n) .ne. -1) then
			go to 100
		endif
		
		visited(x, y, d + 1, n) = cost

		do i = 0, 3
			tempx = x + geth(i)
			tempy = y + getv(i)
			tempd = i
			if ( tempd .ne. d ) then
				tempn = 1
			else
				tempn = n + 1
			end if
			does_not_go_back = (.not.( mod(tempd + 2, 4) == d ))

			is_in = (1 <= tempx .and. tempx <= rows .and. 1 <= tempy .and. tempy <= cols)

			if ( is_in .and. does_not_go_back .and. 1 <= tempn .and. tempn <= 3) then
				tempc = cost + grid(tempx, tempy)
				call positions%enqueue(tempx, tempy, tempd, tempn, tempc)
			endif
		enddo

		100 x = x
	enddo

	dist = 100000
	do d = 1, 4
		do n = 1, 10
			if ( visited(rows, cols, d, n) .ne. -1 .and. visited(rows, cols, d, n) < dist) then
				dist = visited(rows, cols, d, n)
			end if
		end do
	end do

	print*, 'Part 1 : ', dist

	do i = 1, rows, 1
		do j = 1, cols, 1
			visited(i,j,:,:) = -1
		end do
		!write(*,*) grid(i,:)
	end do

	call positions%enqueue(1, 1, -1, -1, 0) 

	do while(positions%n > 0)
		val = positions%top()
		x = val%x
		y = val%y
		d = val%d
		n = val%n
		cost = val%cost

		if (n == -1 .or. d == -1) then
			go to 300
		end if
		if (visited(x, y, d + 1, n) .ne. -1) then
			go to 200
		endif
		
		visited(x, y, d + 1, n) = cost


		300 do i = 0, 3
			tempx = x + geth(i)
			tempy = y + getv(i)
			tempd = i
			if ( tempd .ne. d ) then
				tempn = 1
			else
				tempn = n + 1
			end if
			does_not_go_back = (.not.( mod(tempd + 2, 4) == d ))

			is_in = (1 <= tempx .and. tempx <= rows .and. 1 <= tempy .and. tempy <= cols)

			if ( is_in .and. does_not_go_back .and. (4 <= n .or. n == -1 .or. tempd == d) .and. tempn <= 10) then
				tempc = cost + grid(tempx, tempy)
				call positions%enqueue(tempx, tempy, tempd, tempn, tempc)
			endif
		enddo

		200 x = x
	enddo

	dist = 100000
	do d = 1, 4
		do n = 4, 10
			if ( visited(rows, cols, d, n) .ne. -1 .and. visited(rows, cols, d, n) < dist) then
				dist = visited(rows, cols, d, n)
			end if
		end do
	end do

	print*, 'Part 2 : ', dist

	close(42)

end program clumsy_crucible